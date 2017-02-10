<?php
	
	// --------------------------------------------------------------------------------
	// Save participant identifier. Format: C00000 (C, followed by 5 digits)
	// Example: C00001, C00002, C00003, C00004 
	// -------------------------------------------------------------------------------- 
	
	// Find last used ID
	$lastParticipant = 
		$this->Participant->find('first', array(
			'conditions' => array('Participant.deleted' => array(0,1)),
			'order' => array('Participant.participant_identifier' => 'desc')));
	$lastID = $lastParticipant['Participant']['participant_identifier'];

	// Increment last used participant ID by one
	$newID = ltrim($lastID, 'C');
	$newID = $newID+1;
	if ($newID < 10) {
		$newID = 'C0000'.$newID;
	} elseif ($newID < 100) {
		$newID = 'C000'.$newID;
	} elseif ($newID < 1000) {
		$newID = 'C00'.$newID;
	} elseif ($newID < 10000) {
		$newID = 'C0'.$newID;
	} else {
		$newID = 'C'.$newID;
	}

	// Update record with new participant ID
	$query_to_update = "UPDATE participants SET participants.participant_identifier = "."'".$newID."'"." WHERE participants.id = ".$this->Participant->id.";";
	$this->Participant->tryCatchQuery($query_to_update);
	$this->Participant->tryCatchQuery(str_replace("participants", "participants_revs", $query_to_update));