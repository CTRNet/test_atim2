<?php
class TmaSlideUse extends StorageLayoutAppModel {
		
	var $belongsTo = array(       
		'TmaSlide' => array(           
			'className'    => 'StorageLayout.TmaSlide',            
			'foreignKey'    => 'tma_slide_id'),
		'StudySummary' => array(           
			'className'    => 'Study.StudySummary',            
			'foreignKey'    => 'study_summary_id'));
	
	public static $study_model = null;
		
	function validates($options = array()){
		$this->validateAndUpdateTmaSlideUseStudyData();
		
		return parent::validates($options);
	}
	
	function validateAndUpdateTmaSlideUseStudyData() {
		$tma_slide_use_data =& $this->data;
		
		// check data structure
		$tmp_arr_to_check = array_values($tma_slide_use_data);
		if((!is_array($tma_slide_use_data)) || (is_array($tmp_arr_to_check) && isset($tmp_arr_to_check[0]['TmaSlideUse']))) {
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	
		// Launch validation
		if(array_key_exists('FunctionManagement', $tma_slide_use_data) && array_key_exists('autocomplete_tma_slide_use_study_summary_id', $tma_slide_use_data['FunctionManagement'])) {
			$tma_slide_use_data['TmaSlideUse']['study_summary_id'] = null;
			$tma_slide_use_data['FunctionManagement']['autocomplete_tma_slide_use_study_summary_id'] = trim($tma_slide_use_data['FunctionManagement']['autocomplete_tma_slide_use_study_summary_id']);
			$this->addWritableField(array('study_summary_id'));
			if(strlen($tma_slide_use_data['FunctionManagement']['autocomplete_tma_slide_use_study_summary_id'])) {
				// Load model
				if(self::$study_model == null) self::$study_model = AppModel::getInstance("Study", "StudySummary", true);
					
				// Check the aliquot internal use study definition
				$arr_study_selection_results = self::$study_model->getStudyIdFromStudyDataAndCode($tma_slide_use_data['FunctionManagement']['autocomplete_tma_slide_use_study_summary_id']);
	
				// Set study summary id
				if(isset($arr_study_selection_results['StudySummary'])){
					$tma_slide_use_data['TmaSlideUse']['study_summary_id'] = $arr_study_selection_results['StudySummary']['id'];
				}
	
				// Set error
				if(isset($arr_study_selection_results['error'])){
					$this->validationErrors['autocomplete_tma_slide_use_study_summary_id'][] = $arr_study_selection_results['error'];
				}
			}
	
		}
	}
}
?>
