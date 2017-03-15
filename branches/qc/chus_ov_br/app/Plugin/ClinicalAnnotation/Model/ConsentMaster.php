<?php

class ConsentMaster extends ClinicalAnnotationAppModel {
	var $belongsTo = array(        
		'ConsentControl' => array(            
			'className'    => 'ClinicalAnnotation.ConsentControl',            
			'foreignKey'    => 'consent_control_id'),        
		'StudySummary' => array(           
			'className'    => 'Study.StudySummary',            
			'foreignKey'    => 'study_summary_id'));
	
	var $hasMany = array(
		'Collection' => array(
			'className' => 'InventoryManagement.Collection',
			'foreignKey' => 'consent_master_id'));
	
	static public $join_consent_control_on_dup = array('table' => 'consent_controls', 'alias' => 'ConsentControl', 'type' => 'LEFT', 'conditions' => array('consent_masters_dup.consent_control_id = ConsentControl.id'));
	
	public static $study_model = null;
	
	function validates($options = array()){
	
		$this->validateAndUpdateConsentStudyData();
		
		return parent::validates($options);
	}
	
	/**
	 * Check consent study definition and set error if required.
	 */
	
	function validateAndUpdateConsentStudyData() {
		$consent_data =& $this->data;
		
		// check data structure
		$tmp_arr_to_check = array_values($consent_data);
		if((!is_array($consent_data)) || (is_array($tmp_arr_to_check) && isset($tmp_arr_to_check[0]['ConsentMaster']))) {
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	
		// Launch validation
		if(array_key_exists('FunctionManagement', $consent_data) && array_key_exists('autocomplete_consent_study_summary_id', $consent_data['FunctionManagement'])) {
			$consent_data['ConsentMaster']['study_summary_id'] = null;
			$consent_data['FunctionManagement']['autocomplete_consent_study_summary_id'] = trim($consent_data['FunctionManagement']['autocomplete_consent_study_summary_id']);
			$this->addWritableField(array('study_summary_id'));
			if(strlen($consent_data['FunctionManagement']['autocomplete_consent_study_summary_id'])) {
				// Load model
				if(self::$study_model == null) self::$study_model = AppModel::getInstance("Study", "StudySummary", true);
					
				// Check the aliquot internal use study definition
				$arr_study_selection_results = self::$study_model->getStudyIdFromStudyDataAndCode($consent_data['FunctionManagement']['autocomplete_consent_study_summary_id']);
	
				// Set study summary id
				if(isset($arr_study_selection_results['StudySummary'])){
					$consent_data['ConsentMaster']['study_summary_id'] = $arr_study_selection_results['StudySummary']['id'];
				}
	
				// Set error
				if(isset($arr_study_selection_results['error'])){
					$this->validationErrors['autocomplete_consent_study_summary_id'][] = $arr_study_selection_results['error'];
				}
			}
	
		}
	}
	
	/**
	 * Check if a record can be deleted.
	 * 
	 * @param $consent_master_id Id of the studied record.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	function allowDeletion($consent_master_id){
		$arr_allow_deletion = array('allow_deletion' => true, 'msg' => '');

		$collection_model = AppModel::getInstance("InventoryManagement", "Collection", true);
		$returned_nbr = $collection_model->find('count', array('conditions' => array('Collection.consent_master_id' => $consent_master_id)));
		if($returned_nbr > 0){
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_consent_linked_collection';
		}
		return $arr_allow_deletion;
	}	
	
	static function joinOnConsentDup($on_field){
		return array('table' => 'consent_masters', 'alias' => 'consent_masters_dup', 'type' => 'LEFT', 'conditions' => array($on_field.' = consent_masters_dup.id'));
	}
}

?>