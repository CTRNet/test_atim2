<?php

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
		'hepatobiliary-medical_history-medical past history record summary',
		'hepatobiliary-imagery-medical imaging record summary',
		'hepatobiliary-clinical-cirrhosis medical past history');
	
	if(in_array($created_event_type_title, $unique_event_type_list)) {
		// Should be unique
		$tmp_conditions = array(
			'EventMaster.participant_id'=>$participant_id,
			'EventControl.disease_site'=>$event_control_data['EventControl']['disease_site'],
			'EventControl.event_group'=>$event_group,
			'EventControl.event_type'=>$event_control_data['EventControl']['event_type']);
		
		$existing_event_count = $this->EventMaster->find('count', array('conditions'=>array($tmp_conditions)));
		if($existing_event_count != 0) {
			$this->flash( 'this type of event has already been created for your participant', '/clinicalannotation/event_masters/listall/'.$event_group.'/'.$participant_id );
			return;
		}
	}
	
	// --------------------------------------------------------------------------------
	// hepatobiliary-lab-biology : 
	//   Set participant surgeries list for hepatobiliary-lab-biology.
	// --------------------------------------------------------------------------------
	$surgeries_for_lab_report = $this->EventMaster->getParticipantSurgeriesList($event_control_data, $participant_id);
	if(!is_null($surgeries_for_lab_report)) $this->set('surgeries_for_lab_report', $surgeries_for_lab_report);	
	
?>