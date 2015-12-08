<?php

class ParticipantCustom extends Participant {
	var $useTable = 'participants';
	var $name = 'Participant';
	
	function summary($variables=array()){
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));	
			
			$bank_identfiers = CONFIDENTIAL_MARKER;
			if($result['Participant']['qc_tf_qbcf_bank_participant_identifier'] != CONFIDENTIAL_MARKER) {	
				$bank_model = AppModel::getInstance('Administrate', 'Bank', true);
				$bank = $bank_model->find('first', array('conditions' => array('Bank.id' => $result['Participant']['qc_tf_qbcf_bank_id'])));
				$bank_identfiers = (empty($bank['Bank']['name'])? '?' : $bank['Bank']['name']). ' : '. $result['Participant']['qc_tf_qbcf_bank_participant_identifier'];
			}
			
			$label = $bank_identfiers . ' ['. $result['Participant']['participant_identifier'] .']';
			$return = array(
				'menu'				=>	array( NULL, $label ),
				'title'				=>	array( NULL, $label),
				'structure alias' 	=> 'participants',
				'data'				=> $result
			);
			
// 			$diagnosis_model = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster", true);
// 			$treatment_model = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
// 			$all_participant_dx = $diagnosis_model->find('all', array('conditions' => array('DiagnosisMaster.participant_id' => $variables['Participant.id'], 'DiagnosisControl.category' => 'primary', 'DiagnosisControl.controls_type' => 'prostate'), 'recursive' => '0'));
// 			foreach($all_participant_dx as $new_dx) {
// 				$is_biopsy_turp_dx_method = in_array($new_dx['DiagnosisDetail']['tool'], array('biopsy', 'TURP', 'TRUS-guided biopsy'))? true : false;
// 				$all_linked_diagmosises_ids = $diagnosis_model->getAllTumorDiagnosesIds($new_dx['DiagnosisMaster']['id']);
// 				//Get Biopsy 'dx Bx'
// 				$conditions = array(
// 					'TreatmentMaster.diagnosis_master_id'=> $all_linked_diagmosises_ids,
// 					'TreatmentDetail.type' => $treatment_model->dx_biopsy_and_turp_types,
// 				);
// 				$joins = array(array(
// 					'table' => 'qc_tf_qbcf_txd_biopsies_and_turps',
// 					'alias'	=> 'TreatmentDetail',
// 					'type'	=> 'INNER',
// 					'conditions' => array('TreatmentMaster.id = TreatmentDetail.treatment_master_id')));
// 				$biopsy_turp_at_dx = $treatment_model->find('first', array('conditions'=>$conditions, 'joins' => $joins));
// 				//checks
// 				if(empty($biopsy_turp_at_dx) && $is_biopsy_turp_dx_method) {
// 					AppController::addWarningMsg(__('the biopsy or the turp used for the diagnosis is missing into the system'));
// 				} else if(!empty($biopsy_turp_at_dx) && !$is_biopsy_turp_dx_method) {
// 					AppController::addWarningMsg(__('a biopsy or a turp is defined as diagnosis method but the method of the diagnosis is set to something else'));
// 				} else if($biopsy_turp_at_dx && $is_biopsy_turp_dx_method) {
// 					if($biopsy_turp_at_dx['TreatmentMaster']['start_date'] != $new_dx['DiagnosisMaster']['dx_date'] || $biopsy_turp_at_dx['TreatmentMaster']['start_date_accuracy'] != $new_dx['DiagnosisMaster']['dx_date_accuracy']) {
// 						AppController::addWarningMsg(__('the date of the biopsy or turp used for diagnosis is different than the date of diagnosis'));
// 					}
// 					if(($new_dx['DiagnosisDetail']['tool'] ==  'biopsy'  && $biopsy_turp_at_dx['TreatmentDetail']['type'] != 'Bx Dx') ||
// 					($new_dx['DiagnosisDetail']['tool'] ==  'TURP'  && $biopsy_turp_at_dx['TreatmentDetail']['type'] != 'TURP Dx') ||
// 					($new_dx['DiagnosisDetail']['tool'] ==  'TRUS-guided biopsy'  && $biopsy_turp_at_dx['TreatmentDetail']['type'] != 'Bx Dx TRUS-Guided')) {
// 							AppController::addWarningMsg(__('the method of the diagnosis (biopsy, TRUS-guided biopsy or TURP) is different than the type set for the biopsy or a turp record'));
// 					}
// 				}
// 			}
		}
		
		return $return;
	}
	
	function validates($options = array()){
		$result = parent::validates($options);
		
		if(array_key_exists('qc_tf_qbcf_bank_id', $this->data['Participant'])) {
			$conditions = array(
				'Participant.qc_tf_qbcf_bank_id'=> $this->data['Participant']['qc_tf_qbcf_bank_id'], 
				'Participant.qc_tf_qbcf_bank_participant_identifier'=> $this->data['Participant']['qc_tf_qbcf_bank_participant_identifier']);
			if($this->id) $conditions[] = 'Participant.id != '.$this->id;
			
			$count = $this->find('count', array('conditions'=> $conditions));
			if($count) {
				$this->validationErrors['qc_tf_qbcf_bank_participant_identifier'][] = 'this bank participant identifier has already been assigned to a patient of this bank';
				$result = false;
			}
		}
		
		return $result;
	}
	
	function beforeFind($queryData){
		if(($_SESSION['Auth']['User']['group_id'] != '1')
		&& is_array($queryData['conditions'])
		&& AppModel::isFieldUsedAsCondition("Participant.qc_tf_qbcf_bank_participant_identifier", $queryData['conditions'])) {	
			AppController::addWarningMsg(__('your search will be limited to your bank'));
			$GroupModel = AppModel::getInstance("", "Group", true);
			$group_data = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
			$user_bank_id = $group_data['Group']['bank_id'];
			$queryData['conditions'][] = array("Participant.qc_tf_qbcf_bank_id" => $user_bank_id);
		}
		return $queryData;
	}
	
	function afterFind($results, $primary = false){
		$results = parent::afterFind($results);
		if($_SESSION['Auth']['User']['group_id'] != '1') {
			$GroupModel = AppModel::getInstance("", "Group", true);
			$group_data = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
			$user_bank_id = $group_data['Group']['bank_id'];	
			if(isset($results[0]['Participant']['qc_tf_qbcf_bank_id']) || isset($results[0]['Participant']['qc_tf_qbcf_bank_participant_identifier'])) {
				foreach($results as &$result){
					if((!isset($result['Participant']['qc_tf_qbcf_bank_id'])) || $result['Participant']['qc_tf_qbcf_bank_id'] != $user_bank_id) {			
						$result['Participant']['qc_tf_qbcf_bank_id'] = CONFIDENTIAL_MARKER;
						$result['Participant']['qc_tf_qbcf_bank_participant_identifier'] = CONFIDENTIAL_MARKER;
					}
				}
			} else if(isset($results['Participant'])){
				pr('TODO afterFind participants');
				pr($results);
				exit;
			}
		}

		return $results;
	}

}

?>