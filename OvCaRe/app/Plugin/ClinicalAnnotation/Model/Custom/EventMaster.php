<?php

class EventMasterCustom extends EventMaster {
	var $name = 'EventMaster';
	var $useTable = 'event_masters';
	
	var $belongsTo = array(        
	   'EventControl' => array(            
	       'className'    => 'ClinicalAnnotation.EventControl',            
	       'foreignKey'    => 'event_control_id'        
	   ),        
		'StudySummary' => array(           
			'className'    => 'Study.StudySummary',            
			'foreignKey'    => 'ovcare_study_summary_id'
		)
			
	);
	
	public static $study_model = null;
	
	function validates($options = array()) {
		parent::validates($options);
	
		if(isset($this->data['EventDetail']) && array_key_exists('vital_status', $this->data['EventDetail'])) {
			if(empty($this->data['EventMaster']['event_date'])){ 
				$this->validationErrors['result'][] = 'follow-up date can not be empty';
			}
		}
		
		if(array_key_exists('FunctionManagement', $this->data) && array_key_exists('ovcare_autocomplete_event_study_summary_id', $this->data['FunctionManagement'])) {
			$this->data['EventMaster']['ovcare_study_summary_id'] = null;
			$this->data['FunctionManagement']['ovcare_autocomplete_event_study_summary_id'] = trim($this->data['FunctionManagement']['ovcare_autocomplete_event_study_summary_id']);
			$this->addWritableField(array('ovcare_study_summary_id'));
			if(strlen($this->data['FunctionManagement']['ovcare_autocomplete_event_study_summary_id'])) {
				// Load model
				if(self::$study_model == null) self::$study_model = AppModel::getInstance("Study", "StudySummary", true);
					
				// Check the aliquot internal use study definition
				$arr_study_selection_results = self::$study_model->getStudyIdFromStudyDataAndCode($this->data['FunctionManagement']['ovcare_autocomplete_event_study_summary_id']);
				
				// Set study summary id
				if(isset($arr_study_selection_results['StudySummary'])){
					$this->data['EventMaster']['ovcare_study_summary_id'] = $arr_study_selection_results['StudySummary']['id'];
				}
		
				// Set error
				if(isset($arr_study_selection_results['error'])){
					$this->validationErrors['ovcare_autocomplete_event_study_summary_id'][] = $arr_study_selection_results['error'];
				}
			}
		
		}
				
		return empty($this->validationErrors);
	}
	
}
?>