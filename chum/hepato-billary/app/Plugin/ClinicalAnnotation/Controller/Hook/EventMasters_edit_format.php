<?php
			
	// --------------------------------------------------------------------------------
	// hepatobiliary-lab-biology : 
	//   Set participant surgeries list for hepatobiliary-lab-biology.
	// --------------------------------------------------------------------------------
	$event_control_data = array('EventControl' => $event_master_data['EventControl']);
	$surgeries_for_lab_report = $this->EventMaster->getParticipantSurgeriesList($event_control_data, $participant_id);
	if(!is_null($surgeries_for_lab_report)) $this->set('surgeries_for_lab_report', $surgeries_for_lab_report);
	
?>