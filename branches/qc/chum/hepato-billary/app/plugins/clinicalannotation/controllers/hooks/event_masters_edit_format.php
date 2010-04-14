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
	// lab.hepatobiliary.biology: 
	//   Add date and summary to the lab report
	// --------------------------------------------------------------------------------

	
	
	$this->Structures->set('qc_hb_date', 'qc_hb_date');
	
	$event_control_data = array('EventControl' => $this->data['EventControl']);
	$this->setMedicalImaginStructures($event_control_data);
	

?>
