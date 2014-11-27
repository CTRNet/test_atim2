<?php
	
	// --------------------------------------------------------------------------------
	// Save participant identifier. Format: C00000 (C, followed by 5 digits)
	// Example: C00001, C00002, C00003, C00004 array(1,0) 
	// -------------------------------------------------------------------------------- 
	
	// Find last used ID
	$lastParticipant = 
		$this->Participant->find('first', array(
			'conditions' => array('Participant.deleted' => array(0,1)),
			'order' => array('Participant.participant_identifier' => 'desc')));
	$lastID = $lastParticipant['Participant']['participant_identifier'];

	// Increment last used participant ID by one
	$newID = substr($lastID, 1);
	$newID = $newID+1;
	$newID = "C".$newID;
	
	// Update record with new participant ID
	$query_to_update = "UPDATE participants SET participants.participant_identifier = "."'".$newID."'"." WHERE participants.id = ".$this->Participant->id.";";
	$this->Participant->tryCatchQuery($query_to_update);
	$this->Participant->tryCatchQuery(str_replace("participants", "participants_revs", $query_to_update));