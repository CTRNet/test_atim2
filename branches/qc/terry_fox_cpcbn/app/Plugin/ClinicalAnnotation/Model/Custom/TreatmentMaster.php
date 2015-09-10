<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $useTable = 'treatment_masters';
	var $name = 'TreatmentMaster';
	
	var $dx_biopsy_and_turp_types = array('TURP Dx', 'Bx Dx', 'Bx Dx TRUS-Guided');
	
	function validates($options = array()){
		$result = parent::validates($options);
		$treatment_control = null;
		$all_linked_diagmosises_ids = null;
		
		//check qc_tf_disease_free_survival_start_events can be set to 1
		if(array_key_exists('qc_tf_disease_free_survival_start_events', $this->data['TreatmentMaster']) && $this->data['TreatmentMaster']['qc_tf_disease_free_survival_start_events']) {
			$treatment_control = $this->getTreatmentControlData();
			if(!in_array($treatment_control['TreatmentControl']['tx_method'], array('hormonotherapy', 'RP', 'radiation', 'chemotherapy'))) {
				$this->validationErrors['qc_tf_disease_free_survival_start_events'][] = "this treatment can not be defined as the 'disease free survival start event'";
				$result = false;
			} else if($this->data['TreatmentMaster']['diagnosis_master_id']) {
				// Get all diagnoses linked to the same primary
				$diagnosis_model = AppModel::getInstance('ClinicalAnnotation', 'DiagnosisMaster', true);
				$all_linked_diagmosises_ids = $diagnosis_model->getAllTumorDiagnosesIds($this->data['TreatmentMaster']['diagnosis_master_id']);
				// Search existing 	trt linked to this cancer and already flagged as qc_tf_disease_free_survival_start_events	
				$conditions = array(
					'TreatmentMaster.diagnosis_master_id'=> $all_linked_diagmosises_ids, 
					'TreatmentMaster.qc_tf_disease_free_survival_start_events'=> '1');
				if($this->id) $conditions[] = 'TreatmentMaster.id != '.$this->id;
				$count = $this->find('count', array('conditions'=>$conditions));	
				if($count) {
					$this->validationErrors['qc_tf_disease_free_survival_start_events'][] = "a treatment or biopsy has already been defined as the 'disease free survival start event' for this cancer";
					$result = false;
				}
			}
		}
		
		//check Dx Bx can only be created once per dx
		if(isset($this->data['TreatmentDetail']) && array_key_exists('type', $this->data['TreatmentDetail']) && in_array($this->data['TreatmentDetail']['type'], $this->dx_biopsy_and_turp_types) && $this->data['TreatmentMaster']['diagnosis_master_id']) {
			if(!$treatment_control) $treatment_control = $this->getTreatmentControlData();		
			if($treatment_control['TreatmentControl']['tx_method'] == 'biopsy and turp') {
				// Get all diagnoses linked to the same primary
				$diagnosis_model = AppModel::getInstance('ClinicalAnnotation', 'DiagnosisMaster', true);
				if(!$all_linked_diagmosises_ids) $all_linked_diagmosises_ids = $diagnosis_model->getAllTumorDiagnosesIds($this->data['TreatmentMaster']['diagnosis_master_id']);
				// Search existing 	biopsies linked to this cancer and already flagged as Dx Bx				
				$conditions = array(
					'TreatmentMaster.diagnosis_master_id'=> $all_linked_diagmosises_ids,
					'TreatmentDetail.type' => $this->dx_biopsy_and_turp_types
				);			
				if($this->id) $conditions['NOT'] = array('TreatmentMaster.id' => $this->id);			
				$joins = array(array(
					'table' => 'qc_tf_txd_biopsies_and_turps',
					'alias'	=> 'TreatmentDetail',
					'type'	=> 'INNER',
					'conditions' => array('TreatmentMaster.id = TreatmentDetail.treatment_master_id')));
				$count = $this->find('count', array('conditions'=>$conditions, 'joins' => $joins));
				if($count) {
					$this->validationErrors['type'][] = "a biopsy or a turp has already been defined as the diagnosis method for this cancer";
					$result = false;
				}
			}
		}
		
		return $result;
	}
	
	private function getTreatmentControlData() {
		$treatment_control_id  = null;
		if(isset($this->data['TreatmentMaster']['treatment_control_id'])) {
			$treatment_control_id  = $this->data['TreatmentMaster']['treatment_control_id'];
		} else {
			$tx = $this->find('first', array('conditions' => array('TreatmentMaster.id' => $this->id), 'recursive' => '-1'));
			$treatment_control_id = $tx['TreatmentMaster']['treatment_control_id'];
		}
		$treatment_control_model = AppModel::getInstance('ClinicalAnnotation', 'TreatmentControl', true);
		$treatment_control = $treatment_control_model->find('first', array('conditions' => array('TreatmentControl.id' => $treatment_control_id)));
		return $treatment_control;
	}
	
	function atimDelete( $tx_master_id, $cascade = true ) {
		$deleted_tx_data = $this->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id)));
		$result = parent::atimDelete($tx_master_id);
		if($result && array_key_exists('qc_tf_disease_free_survival_start_events', $deleted_tx_data['TreatmentMaster']) && $deleted_tx_data['TreatmentMaster']['qc_tf_disease_free_survival_start_events'] && $deleted_tx_data['TreatmentMaster']['diagnosis_master_id']) {
			$diagnosis_model = AppModel::getInstance('ClinicalAnnotation', 'DiagnosisMaster', true);
			$diagnosis_model->calculateSurvivalAndBcr($deleted_tx_data['TreatmentMaster']['diagnosis_master_id']);
		}
		return $result;
	}
		
	function afterSave($created, $options = Array()){
		parent::afterSave($created, $options);
		
		if($this->name == 'TreatmentMaster'){
			$tx = $this->find('first', array('conditions' => array('TreatmentMaster.id' => $this->id, 'deleted' => array('0', '1')), 'recursive' => '0'));
			if($tx['TreatmentControl']['tx_method'] == 'biopsy and turp' || $tx['TreatmentControl']['tx_method'] == 'RP') {
				$participant_id = $tx['TreatmentMaster']['participant_id'];
				$diagnosis_model = AppModel::getInstance('ClinicalAnnotation', 'DiagnosisMaster', true);
				$prostate_dxs = $diagnosis_model->find('all', array('conditions' => array('DiagnosisMaster.participant_id' => $participant_id, 'DiagnosisControl.category' => 'primary', 'DiagnosisControl.controls_type' => 'prostate')));
				foreach($prostate_dxs as $participant_prostate_dx) {
					$diagnosis_detail_data_tu_update = array();
					$all_linked_diagmosises_ids = $diagnosis_model->getAllTumorDiagnosesIds($participant_prostate_dx['DiagnosisMaster']['id']);
					//Biopsy/TURP gleason
					$dx_gleason_score_biopsy_turp = $participant_prostate_dx['DiagnosisDetail']['gleason_score_biopsy_turp'];
					$tx_gleason_score_biopsy_turp = '';
					$conditions = array(
						'TreatmentMaster.diagnosis_master_id'=> $all_linked_diagmosises_ids,
						'TreatmentDetail.type' => $this->dx_biopsy_and_turp_types,
						'TreatmentControl.tx_method' => array('biopsy and turp')
					);
					$joins = array(array(
						'table' => 'qc_tf_txd_biopsies_and_turps',
						'alias'	=> 'TreatmentDetail',
						'type'	=> 'INNER',
						'conditions' => array('TreatmentMaster.id = TreatmentDetail.treatment_master_id')));
					$turp_biopsy_dx = $this->find('first', array('conditions'=>$conditions, 'joins' => $joins));				
					if($turp_biopsy_dx) $tx_gleason_score_biopsy_turp = $turp_biopsy_dx['TreatmentDetail']['gleason_score'];
					if($dx_gleason_score_biopsy_turp != $tx_gleason_score_biopsy_turp) $diagnosis_detail_data_tu_update['gleason_score_biopsy_turp'] = $tx_gleason_score_biopsy_turp;
					//Biopsy/TURP ctnm
					$dx_ctnm_biopsy_turp = $participant_prostate_dx['DiagnosisDetail']['ctnm'];
					$tx_ctnm_biopsy_turp = '';
					if($turp_biopsy_dx) $tx_ctnm_biopsy_turp = $turp_biopsy_dx['TreatmentDetail']['ctnm'];
					if($dx_ctnm_biopsy_turp != $tx_ctnm_biopsy_turp) $diagnosis_detail_data_tu_update['ctnm'] = $tx_ctnm_biopsy_turp;
					//RP gleason
					$dx_gleason_score_rp = $participant_prostate_dx['DiagnosisDetail']['gleason_score_rp'];
					$tx_gleason_score_rp = '';
					$conditions = array(
						'TreatmentMaster.diagnosis_master_id'=> $all_linked_diagmosises_ids,
						'TreatmentControl.tx_method' => array('RP')
					);
					$joins = array(array(
						'table' => 'txd_surgeries',
						'alias'	=> 'TreatmentDetail',
						'type'	=> 'INNER',
						'conditions' => array('TreatmentMaster.id = TreatmentDetail.treatment_master_id')));
					$rp = $this->find('first', array('conditions'=>$conditions, 'joins' => $joins));
					if($rp) $tx_gleason_score_rp = $rp['TreatmentDetail']['qc_tf_gleason_score'];
					if($dx_gleason_score_rp != $tx_gleason_score_rp) $diagnosis_detail_data_tu_update['gleason_score_rp'] = $tx_gleason_score_rp;
					//Dx Update
					if($diagnosis_detail_data_tu_update) {
						$diagnosis_data = array('DiagnosisMaster' => array(), 'DiagnosisDetail' => $diagnosis_detail_data_tu_update);				
						$diagnosis_model->id = $participant_prostate_dx['DiagnosisMaster']['id'];
						$diagnosis_model->data = null;
						$diagnosis_model->addWritableField(array('gleason_score_rp', ''));
						$diagnosis_model->save($diagnosis_data, false);
					}
				}
			}
		}
	}	
}

?>