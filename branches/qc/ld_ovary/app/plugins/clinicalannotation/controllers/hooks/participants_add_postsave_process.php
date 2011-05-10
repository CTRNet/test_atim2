<?php

	// --------------------------------------------------------------------------------
	// Save Participant Identifier
	// -------------------------------------------------------------------------------- 
	$participant_identifier =
		strtoupper(substr($this->data['Participant']['first_name'], 0, 1).substr($this->data['Participant']['last_name'], 0, 1)).
		' ('.$this->Participant->id.')';
	if(!$this->Participant->save(array('Participant' => array('participant_identifier' => $participant_identifier)))) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	
?>