<?php
			
	// --------------------------------------------------------------------------------
	// clinical.hepatobiliary.medical imaging *** : 
	//   Set Imaging Structure (other +/- pancreas +/- Semgments +/- etc)
	// --------------------------------------------------------------------------------
	$event_control_data = array('EventControl' => $event_master_data['EventControl']);
	$this->setMedicalImaginStructures($event_control_data);
	
	// --------------------------------------------------------------------------------
	// hepatobiliary-lab-biology : 
	//   Set participant surgeries list for hepatobiliary-lab-biology.
	// --------------------------------------------------------------------------------
	$this->setParticipantSurgeriesList($event_control_data, $participant_id);
	
?>
