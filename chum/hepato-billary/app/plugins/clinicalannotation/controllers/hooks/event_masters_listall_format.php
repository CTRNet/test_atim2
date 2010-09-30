<?php

	// --------------------------------------------------------------------------------
	//   Set IcdCode Description
	// --------------------------------------------------------------------------------
	$this->data = $this->addIcdCodeDescription($this->data);
	
// --------------------------------------------------------------------------------
	// Override Menu For 'clinical' event_group 	 
	// --------------------------------------------------------------------------------
	$is_clinical_group = false;
	if($event_group == 'clinical') {
		$is_clinical_group = true;
	}
	$this->set('is_clinical_group', $is_clinical_group);
		
	// --------------------------------------------------------------------------------
	// Generate both list of :
	//  - disease types for medical history to build 'add medical history' button	
	//  - medical imaging type to build 'add medical imaging' button	
	// --------------------------------------------------------------------------------
	if($is_clinical_group) {
		// 1- MEDICAL PAST HISTORY & MEDICAL IMAGING
		
		// Build list of medical past history event controls
		$medical_past_history_event_controls = array();
		$medical_imaging_event_controls = array();
		foreach($event_controls as $id => $new_control) {
			$med_past_hist_pattern = '/^(.*)_medical_past_history?/';
			$imaging_pattern = '/^qc_hb_imaging(.*)?/';
			
			if(preg_match($med_past_hist_pattern, $new_control['EventControl']['form_alias'])) { 
				$medical_past_history_event_controls[] = $new_control;
				unset($event_controls[$id]);
			} else if(preg_match($imaging_pattern, $new_control['EventControl']['form_alias'])) { 
				$medical_imaging_event_controls[] = $new_control;
				unset($event_controls[$id]);
			}			
		}
		
		$this->set('medical_past_history_event_controls', $medical_past_history_event_controls);
		$this->set('medical_imaging_event_controls', $medical_imaging_event_controls);
		
		
		// Reset event controls for add other button		
		$this->set('event_controls', $event_controls);	
	}	
	
	// --------------------------------------------------------------------------------
	// hepatobiliary-lab-biology : 
	//   Set participant surgeries list for hepatobiliary-lab-biology.
	// --------------------------------------------------------------------------------
	if(!is_null($event_control_id)) {
		// User filtered listed data
		$control_data = $this->EventControl->find('first',array('conditions'=>array('EventControl.id'=>$event_control_id)));
		$this->setParticipantSurgeriesList($control_data, $participant_id);
	}
		
?>
