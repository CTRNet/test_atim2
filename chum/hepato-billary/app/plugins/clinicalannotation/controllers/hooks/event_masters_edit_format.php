<?php

	// --------------------------------------------------------------------------------
	// Override Menu For 'clinical' event_group 	 
	// --------------------------------------------------------------------------------
	if($event_group == 'clinical') {
		$this->set('atim_menu', $this->Menus->get('/clinicalannotation/event_masters/listall/clinical/%%Participant.id%%//'));
	}
			
	// --------------------------------------------------------------------------------
	// clinical.hepatobiliary.*** medical past history: 
	//   Set Medical Past History precisions list
	// --------------------------------------------------------------------------------
	$this->setMedicalPastHistoryPrecisions(array('EventControl' => $event_master_data['EventControl']));
	
	// --------------------------------------------------------------------------------
	// clinical.hepatobiliary.medical imaging *** : 
	//   Set Imaging Structure (other +/- pancreas +/- Semgments +/- etc)
	// --------------------------------------------------------------------------------
	$event_control_data = array('EventControl' => $event_master_data['EventControl']);
	$this->setMedicalImaginStructures($event_control_data);
	
?>
