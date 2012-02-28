<?php

	$this->set('default_sex', 'f');
	
	$last_id = $this->Participant->find('first', array('recursive'=>'-1', 'fields' => array('MAX(participant_identifier)')));
	$default_participant_identifier = floor(empty($last_id[0]['MAX(participant_identifier)'])? 1: $last_id[0]['MAX(participant_identifier)']+1);
	$this->set('default_participant_identifier', $default_participant_identifier);

?>