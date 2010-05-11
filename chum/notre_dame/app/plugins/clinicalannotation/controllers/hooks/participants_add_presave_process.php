<?php

	// --------------------------------------------------------------------------------
	// Set data for anonymous
	// --------------------------------------------------------------------------------
	if($this->data['Participant']['is_anonymous']) {
		if(empty($this->data['Participant']['first_name'])) $this->data['Participant']['first_name'] = 'n/a';
		if(empty($this->data['Participant']['last_name'])) $this->data['Participant']['last_name'] = 'n/a';
	}
	
	// --------------------------------------------------------------------------------
	// Set data for anonymous
	// --------------------------------------------------------------------------------
	$this->data['Participant']['participant_identifier'] = $this->createParticipantIdentifier();
	
?>