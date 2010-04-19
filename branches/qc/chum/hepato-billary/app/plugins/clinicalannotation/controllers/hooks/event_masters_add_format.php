<?php

	// --------------------------------------------------------------------------------
	// Override Menu For 'clinical' event_group 	 
	// --------------------------------------------------------------------------------
	if($event_group == 'clinical') {
		$this->set('atim_menu', $this->Menus->get('/clinicalannotation/event_masters/listall/clinical/%%Participant.id%%//'));
	}

	// --------------------------------------------------------------------------------
	// Check Event Type could be created more than once
	// --------------------------------------------------------------------------------
	$created_event_type_title = 
		$event_control_data['EventControl']['disease_site'].'-'.
		$event_group.'-'.
		$event_control_data['EventControl']['event_type'];
	
	$unique_event_type_list = array(
		'hepatobiliary-clinical-presentation',
		'hepatobiliary-lifestyle-summary',
		'hepatobiliary-clinical-medical past history record summary',
		'hepatobillary-clinical-medical imaging record summary');
		
	if(in_array($created_event_type_title, $unique_event_type_list)) {
		// Should be unique
		$tmp_conditions = array(
			'EventMaster.participant_id'=>$participant_id,
			'EventMaster.disease_site'=>$event_control_data['EventControl']['disease_site'],
			'EventMaster.event_group'=>$event_group,
			'EventMaster.event_type'=>$event_control_data['EventControl']['event_type']);
		
		$existing_event_count = $this->EventMaster->find('count', array('conditions'=>array($tmp_conditions)));
		if($existing_event_count != 0) {
			$this->flash( 'this type of event has already been created for your participant', '/clinicalannotation/event_masters/listall/'.$event_group.'/'.$participant_id );
			return;
		}
	}
	
	// --------------------------------------------------------------------------------
	// clinical.hepatobiliary.*** medical past history: 
	//   Set Medical Past History precisions list
	// --------------------------------------------------------------------------------
	$this->setMedicalPastHistoryPrecisions($event_control_data);
	
	// --------------------------------------------------------------------------------
	// clinical.hepatobiliary.medical imaging *** : 
	//   Set Imaging Structure (other +/- pancreas +/- Semgments +/- etc)
	// --------------------------------------------------------------------------------
	$this->setMedicalImaginStructures($event_control_data);
	
?>