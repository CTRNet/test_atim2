<?php

	// --------------------------------------------------------------------------------
	// Save Participant Identifier
	// -------------------------------------------------------------------------------- 
	$query_to_update = "UPDATE participants SET participants.participant_identifier = participants.id WHERE participants.id = ".$this->Participant->id.";";
	if(!$this->Participant->query($query_to_update) 
	|| !$this->Participant->query(str_replace("participants", "participants_revs", $query_to_update))) {
		$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
	}
	
?>