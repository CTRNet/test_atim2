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
	$this->setMedicalPastHistoryPrecisions(array('EventControl' => $this->data['EventControl']));
	
?>
