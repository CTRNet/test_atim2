<?php

class DiagnosisMaster extends ClinicalAnnotationAppModel {
	var $belongsTo = array(        
		'DiagnosisControl' => array(            
		'className'    => 'ClinicalAnnotation.DiagnosisControl',            
		'foreignKey'    => 'diagnosis_control_id'
		),
	);
	
	var $hasMany = array(
		'Collection' => array(
			'className' => 'InventoryManagement.Collection',
			'foreignKey' => 'diagnosis_master_id'));
	
	static public $join_diagnosis_control_on_dup = array('table' => 'diagnosis_controls', 'alias' => 'DiagnosisControl', 'type' => 'LEFT', 'conditions' => array('diagnosis_masters_dup.diagnosis_control_id = DiagnosisControl.id'));
	
	function primarySummary($variables=array()) {
		return $this->summary($variables['DiagnosisMaster.primary_id']);
	}
	function progression1Summary($variables=array()) {
		return $this->summary($variables['DiagnosisMaster.progression_1_id']);
	}
	function progression2Summary($variables=array()) {
		return $this->summary($variables['DiagnosisMaster.progression_2_id']);
	}
	function summary( $diagnosis_master_id = null ) {
		$return = false;
		if ( !is_null($diagnosis_master_id) ) {
			$result = $this->find('first', array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id), 'recursive' => 0));
			
			$structure_alias = 'diagnosismasters';
			switch($result['DiagnosisControl']['category']) {
				case 'primary':
					if($result['DiagnosisControl']['controls_type'] != 'primary diagnosis unknown') $structure_alias .= ',dx_primary';
					break;
				case 'secondary':
					$structure_alias = ',dx_secondary';
					break;
			}
			
			$return = array(
					'menu' 				=> array(NULL, __($result['DiagnosisControl']['category'], TRUE) . ' - '. __($result['DiagnosisControl']['controls_type'], TRUE)),
					'title' 			=> array(NULL,  __($result['DiagnosisControl']['category'], TRUE)),
					'data'				=> $result,
					'structure alias'	=> $structure_alias
			);
			
		}
		return $return;
	}
	
	/**
	 * Replaces icd10 empty string to null values to respect foreign keys constraints
	 * @param $participantArray
	 */
	function patchIcd10NullValues(&$participant_array){
		if(array_key_exists('icd10_code', $participant_array['DiagnosisMaster']) && strlen(trim($participant_array['DiagnosisMaster']['icd10_code'])) == 0){
			$participant_array['DiagnosisMaster']['icd10_code'] = null;
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
		$nbr_primary = $this->find('count', array('conditions' => array('DiagnosisMaster.primary_id' => $diagnosis_master_id, "DiagnosisMaster.id != $diagnosis_master_id"), 'recursive' => '-1'));
		if ($nbr_primary > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_diagnosis_primary_id';
		}

		// Check for existing records linked to the participant. If found, set error message and deny delete
		$nbr_parent = $this->find('count', array('conditions' => array('DiagnosisMaster.parent_id' => $diagnosis_master_id), 'recursive' => '-1'));
		if ($nbr_parent > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_diagnosis_parent_id';
		}
		
		// Check for existing records linked to the participant. If found, set error message and deny delete
		$collection_model = AppModel::getInstance("InventoryManagement", "Collection", true);
		$nbr_linked_collection = $collection_model->find('count', array('conditions' => array('Collection.diagnosis_master_id' => $diagnosis_master_id)));
		if ($nbr_linked_collection > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_diagnosis_linked_collection';
		}
		
		$event_master_model = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
		$nbr_events = $event_master_model->find('count', array('conditions'=>array('EventMaster.diagnosis_master_id'=>$diagnosis_master_id)));
		if ($nbr_events > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_diagnosis_linked_events';
		}

		$treatment_master_model = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
		$nbr_treatment = $treatment_master_model->find('count', array('conditions'=>array('TreatmentMaster.diagnosis_master_id'=>$diagnosis_master_id)));
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
	
	function hasChild(array $diagnosis_master_ids){
		$tx_model = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
		$event_master_model = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
		return array_merge($this->find('list', array(
				'fields'		=> array('DiagnosisMaster.parent_id'),
				'conditions'	=> array('DiagnosisMaster.parent_id' => $diagnosis_master_ids),
				'group'			=> array('DiagnosisMaster.parent_id')
			)), $tx_model->find('list', array(
				'fields'		=> array('TreatmentMaster.diagnosis_master_id'),
				'conditions'	=> array('TreatmentMaster.diagnosis_master_id' => $diagnosis_master_ids),
				'group'			=> array('TreatmentMaster.diagnosis_master_id')
			)), $event_master_model->find('list', array(
				'fields'		=> array('EventMaster.diagnosis_master_id'),
				'conditions'	=> array('EventMaster.diagnosis_master_id' => $diagnosis_master_ids),
				'group'			=> array('EventMaster.diagnosis_master_id')
			))
		);
	}
	
	/**
	 * Arranges the threaded data
	 */
	function arrangeThreadedDataForView(array &$threaded_dx_data, $seeking_dx_id, $seeking_model_name){
		$stack = array();
		$current_array = &$threaded_dx_data;
		$found_dx = false;
		foreach($threaded_dx_data as &$data){
			if($data['DiagnosisMaster']['id'] == $seeking_dx_id){
				$data[$seeking_model_name]['diagnosis_master_id'] = $seeking_dx_id;
				$found_dx = true;
				break;
			}
			if(isset($data['children']) && !empty($data['children'])){
				if($found_dx = $this->arrangeThreadedDataForView($data['children'], $seeking_dx_id, $seeking_model_name)){
					break;
				}
			}
		}
		
		return $found_dx;
	}
	
	function getRelatedDiagnosisEvents($diagnosis_master_id) {
		
		$related_diagnosis_data = array();
		
		if(!empty($diagnosis_master_id)) {
			$event_diagnosis_data = $this->getOrRedirect($diagnosis_master_id);
			$related_diagnosis_data[] = array_merge(array('Generated' => array('diagnosis_event_relation_type' => 'diagnosis event')), $event_diagnosis_data);
			
			$history_diagnosis_data = array();
			if($event_diagnosis_data['DiagnosisMaster']['id'] != $event_diagnosis_data['DiagnosisMaster']['primary_id']) {
				$history_diagnosis_data = $this->find('all', array('conditions'=>array('DiagnosisMaster.id' => array($event_diagnosis_data['DiagnosisMaster']['primary_id'], $event_diagnosis_data['DiagnosisMaster']['parent_id'])), 'order' => 'DiagnosisMaster.id DESC'));
				if(empty($history_diagnosis_data)){
					AppController::getInstance()->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
				}
				foreach($history_diagnosis_data as $new_diag) {
					$related_diagnosis_data[] = array_merge(array('Generated' => array('diagnosis_event_relation_type' => 'diagnosis history')), $new_diag);
				}
			}
		}
		
		return $related_diagnosis_data;
	}

	static function joinOnDiagnosisDup($on_field){
		return array('table' => 'diagnosis_masters', 'alias' => 'diagnosis_masters_dup', 'type' => 'LEFT', 'conditions' => array($on_field.' = diagnosis_masters_dup.id'));
	}
}
?>