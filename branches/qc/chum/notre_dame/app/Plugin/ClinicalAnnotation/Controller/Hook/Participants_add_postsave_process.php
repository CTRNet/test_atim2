<?php

// --------------------------------------------------------------------------------
// Save Participant Identifier
// --------------------------------------------------------------------------------
$queryToUpdate = "UPDATE participants SET participants.participant_identifier = participants.id WHERE participants.id = " . $this->Participant->id . ";";
$this->Participant->tryCatchQuery($queryToUpdate);
$this->Participant->tryCatchQuery(str_replace("participants", "participants_revs", $queryToUpdate));