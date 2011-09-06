<?php

	// --------------------------------------------------------------------------------
	// Save Participant Identifier
	// --------------------------------------------------------------------------------
	if($this->Participant->find('count', array('conditions' => array('Participant.participant_identifier' => $this->data['Participant']['participant_identifier']), 'recursive' => '-1'))) {
		$submitted_data_validates = false;
		$this->Participant->validationErrors['participant_identifier'][] = 'the submitted bank number already exists';
	}

?>