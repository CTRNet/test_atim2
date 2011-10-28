<?php

	// --------------------------------------------------------------------------------
	// Save Participant Identifier
	// --------------------------------------------------------------------------------
	if(!$this->Participant->save(array('Participant' => array('participant_identifier' => 'p-'.$this->Participant->id)), false)){
		$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	}
	
?>