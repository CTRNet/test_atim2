<?php
 
 	// --------------------------------------------------------------------------------
	// Add/Access linked lab report
	// -------------------------------------------------------------------------------- 	
	$criteria = array(
		'EventMaster.disease_site' => 'prostate',
		'EventMaster.event_group' => 'lab',
		'EventMaster.event_type' => 'procure path report',
		'EventMaster.participant_id' => $participant_id,
		'EventMaster.diagnosis_master_id' => $diagnosis_master_id);
	$res = $this->EventMaster->find('first', array('conditions' => $criteria));

	if(empty($res)) {
		// Allow user to create lab report for the diagnosis
		
		// Get Lab report event Control
		App::import('Model', 'Clinicalannotation.EventControl');		
		$this->EventControl = new EventControl();	
		
		$event_controls = $this->EventControl->find('all', array('conditions'=>array('EventControl.event_group'=>'lab', 'EventControl.flag_active' => '1' )));

		// Create add links
		$add_links = array();
		foreach ( $event_controls as $event_control ) {
			$add_links[ __($event_control['EventControl']['disease_site'],true).' - '.__($event_control['EventControl']['event_type'],true) ] = '/clinicalannotation/event_masters/add/lab/'.$participant_id.'/'.$event_control['EventControl']['id'];
		}
		$linked_lab_report_link = array('add path report' => $add_links);
		
	} else {
		// Lab report already exists for the diagnosis
		$linked_lab_report_link = array('access path report' => '/clinicalannotation/event_masters/detail/lab/'.$participant_id.'/'.$res['EventMaster']['id']);
	}
	$this->set('linked_lab_report_link', $linked_lab_report_link);
 
?>
