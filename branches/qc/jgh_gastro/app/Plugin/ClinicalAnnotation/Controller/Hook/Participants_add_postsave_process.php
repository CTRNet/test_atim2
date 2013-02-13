<?php

 	// --------------------------------------------------------------------------------
	// Manage Participant creation to generate participant identifier
	// -------------------------------------------------------------------------------- 
	$this->Participant->data = array();					
	$this->Participant->id = $this->Participant->getLastInsertId();					
	$participant_data_to_update = array();
	$this->Participant->addWritableField(array('participant_identifier'));
	$participant_data_to_update['Participant']['participant_identifier'] = 'p-'.$this->Participant->id;
	if(!$this->Participant->save($participant_data_to_update, false)) { $this->redirect('/pages/err_clin_system_error', null, true); }
	
?>