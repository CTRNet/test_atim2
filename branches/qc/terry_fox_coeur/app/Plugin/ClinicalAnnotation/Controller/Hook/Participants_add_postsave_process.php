<?php
	
	// --------------------------------------------------------------------------------
	// Save Participant Identifier
	// -------------------------------------------------------------------------------- 
	$this->Participant->addWritableField(array('participant_identifier'));
	if(!$this->Participant->save(array('Participant' => array('participant_identifier' => $this->Participant->id)))) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	
?>