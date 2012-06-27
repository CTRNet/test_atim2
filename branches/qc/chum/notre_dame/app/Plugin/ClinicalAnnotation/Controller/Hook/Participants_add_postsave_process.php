<?php
	
	// --------------------------------------------------------------------------------
	// Save Participant Identifier
	// -------------------------------------------------------------------------------- 
	$query_to_update = "UPDATE participants SET participants.participant_identifier = participants.id WHERE participants.id = ".$this->Participant->id.";";
	$this->Participant->tryCatchQquery($query_to_update);
	$this->Participant->tryCatchQuery(str_replace("participants", "participants_revs", $query_to_update));
				
