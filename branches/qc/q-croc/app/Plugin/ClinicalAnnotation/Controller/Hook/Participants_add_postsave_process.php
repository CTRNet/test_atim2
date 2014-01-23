<?php 

	$this->Participant->query("UPDATE participants SET participant_identifier = id WHERE participant_identifier = '' OR participant_identifier IS NULL");
	$this->Participant->query("UPDATE participants_revs SET participant_identifier = id WHERE participant_identifier = '' OR participant_identifier IS NULL");

?>