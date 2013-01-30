<?php

class DiagnosisMaster extends ClinicalannotationAppModel {
	var $belongsTo = array(        
		'DiagnosisControl' => array(            
		'className'    => 'Clinicalannotation.DiagnosisControl',            
		'foreignKey'    => 'diagnosis_control_id'
		),
	);
	
	var $hasMany = array(
		'ClinicalCollectionLink' => array(
			'className' => 'Clinicalannotation.ClinicalCollectionLink',
			'foreignKey' => 'diagnosis_master_id'));
	
	function summary( $variables=array() ) {
		$return = false;
		if ( isset($variables['DiagnosisMaster.id']) ) {
			$result = $this->find('first', array('conditions'=>array('DiagnosisMaster.id'=>$variables['DiagnosisMaster.id'])));
			
			$return = array(
					'menu' 				=> array(NULL, __($result['DiagnosisControl']['controls_type'], TRUE)),
					'title' 			=> array(NULL, __('diagnosis', TRUE)),
					'data'				=> $result,
					'structure alias'	=> 'diagnosismasters'
			);
			
		}
		return $return;
	}
	
	/**
	 * Replaces icd10 empty string to null values to respect foreign keys constraints
	 * @param $participantArray
	 */
	function patchIcd10NullValues(&$participant_array){
		if(array_key_exists('primary_icd10_code', $participant_array['DiagnosisMaster']) && strlen(trim($participant_array['DiagnosisMaster']['primary_icd10_code'])) == 0){
			$participant_array['DiagnosisMaster']['primary_icd10_code'] = null;
		}
	}
	
	/**
	 * Check if a record can be deleted.
	 * 
	 * @param $diagnosis_master_id Id of the studied record.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	function allowDeletion($diagnosis_master_id) {
		$arr_allow_deletion = array('allow_deletion' => true, 'msg' => '');
		
		// Check for existing records linked to the participant. If found, set error message and deny delete
		$ccl_model = AppModel::getInstance("Clinicalannotation", "ClinicalCollectionLink", true);
		$nbr_linked_collection = $ccl_model->find('count', array('conditions' => array('ClinicalCollectionLink.diagnosis_master_id' => $diagnosis_master_id, 'ClinicalCollectionLink.deleted'=>0), 'recursive' => '-1'));
		if ($nbr_linked_collection > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_diagnosis_linked_collection';
		}
		
		$event_master_model = AppModel::getInstance("Clinicalannotation", "EventMaster", true);
		$nbr_events = $event_master_model->find('count', array('conditions'=>array('EventMaster.diagnosis_master_id'=>$diagnosis_master_id, 'EventMaster.deleted'=>0), 'recursive' => '-1'));
		if ($nbr_events > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_diagnosis_linked_events';
		}

		$treatment_master_model = AppModel::getInstance("Clinicalannotation", "TreatmentMaster", true);
		$nbr_treatment = $treatment_master_model->find('count', array('conditions'=>array('TreatmentMaster.diagnosis_master_id'=>$diagnosis_master_id, 'TreatmentMaster.deleted'=>0), 'recursive' => '-1'));
		if ($nbr_treatment > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_diagnosis_linked_treatment';
		}		
		return $arr_allow_deletion;
	}

	function getExistingDx($participant_id, $current_dx_id = '0', $current_dx_primary_number = '') {
		$existing_dx = $this->find('all', array('conditions' => array('DiagnosisMaster.participant_id' => $participant_id, 'DiagnosisMaster.id != '.$current_dx_id)));
		//sort by dx number
		if(empty($existing_dx)){
			$sorted_dx[''] = array();
		}else{
			foreach($existing_dx as $dx){
				if(isset($sorted_dx[$dx['DiagnosisMaster']['primary_number']])){
					array_push($sorted_dx[$dx['DiagnosisMaster']['primary_number']], $dx);
				}else{
					$sorted_dx[$dx['DiagnosisMaster']['primary_number']][0] = $dx;
				}
			}
			if(!isset($sorted_dx[''])){
				$sorted_dx[''] = array();
			}
			if(!isset($sorted_dx[$current_dx_primary_number])){
				$sorted_dx[$current_dx_primary_number] = array();			
			}
		}
		ksort($sorted_dx);
		return $sorted_dx;	
	}
}
?>