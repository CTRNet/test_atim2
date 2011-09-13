<?php

	// --------------------------------------------------------------------------------
	// Save Participant Identifier
	// -------------------------------------------------------------------------------- 
	$this->Participant->data = array();
	$participant_identifier = $this->data['Participant']['qc_ldov_initals'].' ('.$this->Participant->id.')';
	if(!$this->Participant->save(array('Participant' => array('participant_identifier' => $participant_identifier)))) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	
?>