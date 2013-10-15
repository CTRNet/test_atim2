<?php
	
	// --------------------------------------------------------------------------------
	// Get next Participant Identifier
	// -------------------------------------------------------------------------------- 
	$this->Participant->addWritableField(array('participant_identifier'));
	$last_participant_identifier = $this->Participant->find('first', array('recursive'=>'-1', 'fields' => array('MAX(participant_identifier)')));
	$next_participant_identifier = empty($last_participant_identifier[0]['MAX(participant_identifier)'])? 1: $last_participant_identifier[0]['MAX(participant_identifier)']+1;
	$this->request->data['Participant']['participant_identifier'] = $next_participant_identifier;
	
?>