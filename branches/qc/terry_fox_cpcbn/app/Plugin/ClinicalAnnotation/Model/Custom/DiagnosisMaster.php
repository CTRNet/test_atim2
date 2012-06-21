<?php

class DiagnosisMasterCustom extends DiagnosisMaster {
	var $useTable = 'diagnosis_masters';
	var $name = 'DiagnosisMaster';
	
	function validates($options = array()){
		$result = parent::validates($options);
	
		if(array_key_exists('first_biochemical_recurrence', $this->data['DiagnosisDetail']) && $this->data['DiagnosisDetail']['first_biochemical_recurrence']) {
			// Get all diagnoses linked to the same primary
			$dx_id_for_search = array_key_exists('primary_id', $this->data['DiagnosisMaster'])? $this->data['DiagnosisMaster']['primary_id'] : $this->id;
			if(empty($dx_id_for_search)) AppController::getInstance()->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
			$all_linked_diagmosises_ids = $this->getAllTumorDiagnosesIds($dx_id_for_search);
			
			// Search existing 	BCR linked to this cancer already flagged as first_biochemical_recurrence
			$conditions = array(
					'DiagnosisMaster.id'=> $all_linked_diagmosises_ids,
					'DiagnosisDetail.first_biochemical_recurrence'=> '1');
			if($this->id) $conditions[] = 'DiagnosisMaster.id != '.$this->id;
			$joins = array(array(
					'table' => 'qc_tf_dxd_recurrence_bio',
					'alias' => 'DiagnosisDetail',
					'type' => 'INNER',
					'conditions'=> array('DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id')));
			$count = $this->find('count', array('conditions'=>$conditions, 'joins' => $joins));
			if($count) {
				$this->validationErrors['first_biochemical_recurrence'][] = "a bcr has already been defined as first bcr for this cancer";
				$result = false;
			}
		}
	
		return $result;
	}
	
	function calculateSurvivalAndBcr($studied_diagnosis_id) {
		if(empty($studied_diagnosis_id)) return;
		
		$all_linked_diagnoses_ids = $this->getAllTumorDiagnosesIds($studied_diagnosis_id);
		$conditions = array(
			'DiagnosisMaster.id' => $all_linked_diagnoses_ids,
			'DiagnosisMaster.deleted != 1',
			'DiagnosisControl.category' => 'primary',
			'DiagnosisControl.controls_type' => 'prostate');
		$prostate_dx = $this->find('first', array('conditions'=>$conditions));
		
		if(!empty($prostate_dx)) {
			$participant_id = $prostate_dx['DiagnosisMaster']['participant_id'];
			$primary_id = $prostate_dx['DiagnosisMaster']['id'];
			$primary_diagnosis_control_id = $prostate_dx['DiagnosisMaster']['diagnosis_control_id'];
			
			$previous_survival = $prostate_dx['DiagnosisDetail']['survival_in_months'];
			$previous_bcr = $prostate_dx['DiagnosisDetail']['bcr_in_months'];
			
			// Get 1st BCR
			
			$conditions = array(
				'DiagnosisMaster.primary_id'=> $primary_id,
				'DiagnosisMaster.deleted != 1',
				'DiagnosisDetail.first_biochemical_recurrence'=> '1',
			);
			$joins = array(array(
				'table' => 'qc_tf_dxd_recurrence_bio',
				'alias' => 'DiagnosisDetail',
				'type' => 'INNER',
				'conditions'=> array('DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id')));
			$bcr = $this->find('first', array('conditions'=>$conditions, 'joins' => $joins));
			
			$bcr_date = $bcr['DiagnosisMaster']['dx_date'];
			$bcr_accuracy = $bcr['DiagnosisMaster']['dx_date_accuracy'];	
			
			// Get 1st DFS
			
			$treatment_master_model = AppModel::getInstance('ClinicalAnnotation', 'TreatmentMaster', true);
			$conditions = array(
				'TreatmentMaster.diagnosis_master_id'=> $all_linked_diagnoses_ids,
				'TreatmentMaster.deleted != 1',
				'TreatmentMaster.qc_tf_disease_free_survival_start_events'=> '1');
			$dfs = $treatment_master_model->find('first', array('conditions' => $conditions));
			
			$dfs_date = $dfs['TreatmentMaster']['start_date'];
			$dfs_accuracy = $dfs['TreatmentMaster']['start_date_accuracy'];		
					
			// Get survival end date
			
			$participant_model = AppModel::getInstance('ClinicalAnnotation', 'Participant', true);
			$participant = $participant_model->find('first', array('conditions' => array('Participant.id' => $participant_id)));
			
			$survival_end_date = '';
			$survival_end_date_accuracy = '';
			if(!empty($participant['Participant']['date_of_death'])) {
				$survival_end_date = $participant['Participant']['date_of_death'];
				$survival_end_date_accuracy = $participant['Participant']['date_of_death_accuracy'];
			} else if(!empty($participant['Participant']['qc_tf_last_contact'])) {
				$survival_end_date = $participant['Participant']['qc_tf_last_contact'];
				$survival_end_date_accuracy = $participant['Participant']['qc_tf_last_contact_accuracy'];
			}
			
			// Calculate Survival
			
			$new_survival = '';
			if(!empty($dfs_date) && !empty($survival_end_date)) {
				if($survival_end_date_accuracy.$dfs_accuracy == 'cc') {				
					$dfs_date_ob = new DateTime($dfs_date);
					$survival_end_date_ob = new DateTime($survival_end_date);
					$interval = $dfs_date_ob->diff($survival_end_date_ob);							
					if($interval->invert) {
						AppController::getInstance()->addWarningMsg(__('survival cannot be calculated because dates are not chronological'));
					} else {	
						$new_survival = $interval->y*12 + $interval->m;
					}
				} else {				
					AppController::getInstance()->addWarningMsg(__('survival cannot be calculated on inaccurate dates'));
				}
			}
		
			// Calculate bcr
			
			$new_bcr = '';
			if(!empty($dfs_date) && !empty($bcr_date)) {
				if($dfs_accuracy.$bcr_accuracy == 'cc') {
					$dfs_date_ob = new DateTime($dfs_date);
					$bcr_date_ob = new DateTime($bcr_date);
					$interval = $dfs_date_ob->diff($bcr_date_ob);
					if($interval->invert) {
						AppController::getInstance()->addWarningMsg(__('bcr cannot be calculated because dates are not chronological'));
					} else {			
						$new_bcr = $interval->y*12 + $interval->m;
					}							
				} else {
					AppController::getInstance()->addWarningMsg(__('bcr cannot be calculated on inaccurate dates'));				
				}	
			} else {
				$new_bcr = $new_survival;
			}
			
			// Data to update
			
			$data_to_update = array('DiagnosisMaster' => array('diagnosis_control_id' => $primary_diagnosis_control_id));
			if($new_bcr != $previous_bcr) $data_to_update['DiagnosisDetail']['bcr_in_months'] = $new_bcr;
			if($new_survival != $previous_survival) $data_to_update['DiagnosisDetail']['survival_in_months'] = $new_survival;
			if(sizeof($data_to_update) != 1) {
				$thid->data = array();
				$this->id = $primary_id;
				if(!$this->save($data_to_update)) AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
			}
		}
	}
	
	function getAllTumorDiagnosesIds($diagnosis_master_id) {
		$all_linked_diagmosises_ids = array();
		$studied_diagnosis_data = $this->find('first', array('conditions' => array('DiagnosisMaster.id' => $diagnosis_master_id), 'recursive' => '-1'));
		if(!empty($studied_diagnosis_data)) {
			$all_linked_diagmosises = $this->find('all', array('conditions' => array('DiagnosisMaster.primary_id' => $studied_diagnosis_data['DiagnosisMaster']['primary_id']), 'fields' => array('DiagnosisMaster.id'), 'recursive' => '-1'));
			$all_linked_diagmosises_ids = array();
			foreach($all_linked_diagmosises as $new_dx) $all_linked_diagmosises_ids[] = $new_dx['DiagnosisMaster']['id'];
		}
		return $all_linked_diagmosises_ids;
	}
	
	function atimDelete( $diagnosis_master_id ) {
		$deleted_diagnosis_master_data = $this->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id)));
		$result = parent::atimDelete($diagnosis_master_id);
		if($result && array_key_exists('first_biochemical_recurrence', $deleted_diagnosis_master_data['DiagnosisDetail']) && $deleted_diagnosis_master_data['DiagnosisDetail']['first_biochemical_recurrence']) {
			$this->calculateSurvivalAndBcr($deleted_diagnosis_master_data['DiagnosisMaster']['primary_id']);			
		}
		return $result;
	}
	
}

?>