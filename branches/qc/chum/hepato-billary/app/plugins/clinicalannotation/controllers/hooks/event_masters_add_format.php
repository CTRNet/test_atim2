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
		'hepatobiliary-clinical-medical past history record summary');
		
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
	
	if(strpos($event_control_data['EventControl']['form_alias'], 'qc_hb_imaging_') === 0){
		$tmp_data = $this->EventMaster->find('first', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_control_id' => $event_control_data['EventControl']['id'])));
		if(!empty($tmp_data)){
			$this->flash( 'this report has already been created for your participant', '/clinicalannotation/event_masters/detail/clinical/'.$tmp_data['EventMaster']['participant_id'].'/'.$tmp_data['EventMaster']['id'] );
			return;
		}
	}

	$this->setMedicalImaginStructures($event_control_data);
	
	if($event_control_data['EventControl']['form_alias'] == "ed_hepatobiliary_lab_report_biology"){
		$this->Structures->set('qc_hb_dateNSummary', 'qc_hb_dateNSummary');
	}
	
?>