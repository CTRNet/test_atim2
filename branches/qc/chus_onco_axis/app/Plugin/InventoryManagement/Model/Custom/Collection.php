<?php

class CollectionCustom extends Collection {
	
	var $useTable = 'collections';
	var $name = 'Collection';
	
	private static $study_model = null;
	
	function validates($options = array()) {
		$res = parent::validates($options);
		$collection_data =& $this->data;
		
		// Launch study validation
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
		
		//Ischemia time validation and warm ischemia calculation
		if($res) {
			if(array_key_exists('Collection', $collection_data) && array_key_exists('chus_ischemia_time', $collection_data['Collection'])) {
				if(!array_key_exists('collection_datetime', $collection_data['Collection'])) {
					AppController::addWarningMsg(__("data is missing to calculate the warm ischemia time - warm ischemia time won't be recorded"));
					$collection_data['Collection']['chus_warm_ischemia_time_mn'] = '';
					$this->addWritableField(array('chus_warm_ischemia_time_mn'));
				} else if(empty($collection_data['Collection']['chus_ischemia_time']) && empty($collection_data['Collection']['collection_datetime'])) {
					AppController::addWarningMsg(__("data is missing to calculate the warm ischemia time - warm ischemia time won't be recorded"));
					$collection_data['Collection']['chus_warm_ischemia_time_mn'] = '';
					$this->addWritableField(array('chus_warm_ischemia_time_mn'));
				}else if($collection_data['Collection']['chus_ischemia_time'] && empty($collection_data['Collection']['collection_datetime'])) {
					$this->validationErrors['collection_datetime'][] = 'the system is unable to calculate the warm ischemia time - please check times definitions';
					$res = false;
				} else if(empty($collection_data['Collection']['chus_ischemia_time']) && $collection_data['Collection']['collection_datetime']) {
					AppController::addWarningMsg(__("data is missing to calculate the warm ischemia time - warm ischemia time won't be recorded"));
					$collection_data['Collection']['chus_warm_ischemia_time_mn'] = '';
					$this->addWritableField(array('chus_warm_ischemia_time_mn'));
				} else {
					$collection_datetime = $collection_data['Collection']['collection_datetime'];
					$collection_datetime_accuracy = $collection_data['Collection']['collection_datetime_accuracy'];
					if($collection_datetime_accuracy != 'c') {
						pr('1');
						$this->validationErrors['collection_datetime'][] = 'the system is unable to calculate the warm ischemia time - please check times definitions';
						$res = false;
					} else {
						$chus_ischemia_datetime = preg_replace('/([0-9]{2}:[0-9]{2}:[0-9]{2})$/', $collection_data['Collection']['chus_ischemia_time'], $collection_datetime);
						$spent_time = $this->getSpentTime($chus_ischemia_datetime, $collection_datetime);
						if(!$spent_time['message']) {
							$collection_data['Collection']['chus_warm_ischemia_time_mn'] = $spent_time['minutes'] + $spent_time['hours']*60;
							$this->addWritableField(array('chus_warm_ischemia_time_mn'));
						} else {
							$this->validationErrors['chus_ischemia_time'][] = 'the system is unable to calculate the warm ischemia time - please check times definitions';
							$res = false;
						}
					}
				}
			} else if(array_key_exists('collection_datetime', $collection_data['Collection'])) {	
				AppController::addWarningMsg(__("data is missing to calculate the warm ischemia time - warm ischemia time won't be recorded"));
				$collection_data['Collection']['chus_warm_ischemia_time_mn'] = '';
				$this->addWritableField(array('chus_warm_ischemia_time_mn'));		
			}
		}
		
		return $res;
	}
	
}

?>
