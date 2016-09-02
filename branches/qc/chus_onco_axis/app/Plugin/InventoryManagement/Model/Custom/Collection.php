<?php

class CollectionCustom extends Collection {
	
	var $useTable = 'collections';
	var $name = 'Collection';
	
	private static $study_model = null;
	
	function validates($options = array()) {
		$res = parent::validates($options);
		
		// Launch study validation
		$collection_data =& $this->data;
		if(array_key_exists('FunctionManagement', $collection_data) && array_key_exists('chus_autocomplete_collections_study_summary_id', $collection_data['FunctionManagement'])) {
			$collection_data['Collection']['chus_default_collection_study_summary_id'] = null;
			$collection_data['FunctionManagement']['chus_autocomplete_collections_study_summary_id'] = trim($collection_data['FunctionManagement']['chus_autocomplete_collections_study_summary_id']);
			$this->addWritableField(array('chus_default_collection_study_summary_id'));
			if(strlen($collection_data['FunctionManagement']['chus_autocomplete_collections_study_summary_id'])) {
				// Load model
				if(self::$study_model == null) self::$study_model = AppModel::getInstance("Study", "StudySummary", true);
				// Check the aliquot internal use study definition
				$arr_study_selection_results = self::$study_model->getStudyIdFromStudyDataAndCode($collection_data['FunctionManagement']['chus_autocomplete_collections_study_summary_id']);
				// Set study summary id
				if(isset($arr_study_selection_results['StudySummary'])){
					$collection_data['Collection']['chus_default_collection_study_summary_id'] = $arr_study_selection_results['StudySummary']['id'];
				}
				// Set error
				if(isset($arr_study_selection_results['error'])){
					$this->validationErrors['chus_autocomplete_collections_study_summary_id'][] = $arr_study_selection_results['error'];
					$res = false;
				}
			}
		}
		
		return $res;
	}
	
}

?>
