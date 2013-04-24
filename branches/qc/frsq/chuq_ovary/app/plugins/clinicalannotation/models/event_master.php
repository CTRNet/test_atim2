<?php

class EventMaster extends ClinicalannotationAppModel {
	
	var $belongsTo = array(        
	   'EventControl' => array(            
	       'className'    => 'Clinicalannotation.EventControl',            
	       'foreignKey'    => 'event_control_id'        
	   )    
	);
	
	/**
	 * Compares dx data with a cap report and generates warning when there are
	 * mismatches.
	 * @param array $diagnosis_data
	 * @param array $event_data
	 */
	static function generateDxCompatWarnings(array $diagnosis_data, array $event_data){
		$diagnosis_data = $diagnosis_data['DiagnosisMaster'];
		$event_data = $event_data['EventDetail'];
		
		$to_check = array(
			//field			=> untranslated language label
			'path_tstage'	=> 'path tstage',
			'path_nstage'	=> 'path nstage',
			'path_mstage'	=> 'path mstage',
			'tumour_grade'	=> 'histologic grade'
		);
		foreach($to_check as $field => $language_label){
			if(array_key_exists($field, $event_data) && $diagnosis_data[$field] != $event_data[$field]){
				AppController::addWarningMsg(
					sprintf(
						__('the diagnosis value for %s does not match the cap report value', true), 
						__($language_label, true)
					)
				);
			}
		}
	}
}

?>