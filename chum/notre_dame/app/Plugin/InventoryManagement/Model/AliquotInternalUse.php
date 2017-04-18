<?php

class AliquotInternalUse extends InventoryManagementAppModel {
	
	var $belongsTo = array(       
		'AliquotMaster' => array(           
			'className'    => 'InventoryManagement.AliquotMaster',            
			'foreignKey'    => 'aliquot_master_id'),        
		'StudySummary' => array(           
			'className'    => 'Study.StudySummary',            
			'foreignKey'    => 'study_summary_id'));
	
	var $registered_view = array(
		'InventoryManagement.ViewAliquotUse' => array('AliquotInternalUse.id')
	);

	public static $study_model = null;
	
	function validates($options = array()){
		
		$this->validateAndUpdateAliquotInternalUseStudyData();
		
		return parent::validates($options);
	}
	
	/**
	 * Check internal use study definition and set error if required.
	 */
	
	function validateAndUpdateAliquotInternalUseStudyData() {
		$aliquot_internal_use_data =& $this->data;
	
		// check data structure
		$tmp_arr_to_check = array_values($aliquot_internal_use_data);
		if((!is_array($aliquot_internal_use_data)) || (is_array($tmp_arr_to_check) && isset($tmp_arr_to_check[0]['AliquotInternalUse']))) {
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	
		// Launch validation
		if(array_key_exists('FunctionManagement', $aliquot_internal_use_data) && array_key_exists('autocomplete_aliquot_internal_use_study_summary_id', $aliquot_internal_use_data['FunctionManagement'])) {
			$aliquot_internal_use_data['AliquotInternalUse']['study_summary_id'] = null;
			$aliquot_internal_use_data['FunctionManagement']['autocomplete_aliquot_internal_use_study_summary_id'] = trim($aliquot_internal_use_data['FunctionManagement']['autocomplete_aliquot_internal_use_study_summary_id']);
			if(strlen($aliquot_internal_use_data['FunctionManagement']['autocomplete_aliquot_internal_use_study_summary_id'])) {
				// Load model
				if(self::$study_model == null) self::$study_model = AppModel::getInstance("Study", "StudySummary", true);
					
				// Check the aliquot internal use study definition
				$arr_study_selection_results = self::$study_model->getStudyIdFromStudyDataAndCode($aliquot_internal_use_data['FunctionManagement']['autocomplete_aliquot_internal_use_study_summary_id']);
	
				// Set study summary id
				if(isset($arr_study_selection_results['StudySummary'])){
					$aliquot_internal_use_data['AliquotInternalUse']['study_summary_id'] = $arr_study_selection_results['StudySummary']['id'];
				}
	
				// Set error
				if(isset($arr_study_selection_results['error'])){
					$this->validationErrors['autocomplete_aliquot_internal_use_study_summary_id'][] = $arr_study_selection_results['error'];
				}
			}
	
		}
	}
}

?>
