<?php

	// --------------------------------------------------------------------------------
	// Generate default default_bank_number
	// -------------------------------------------------------------------------------- 
	$last_id = $this->Participant->find('first', array('recursive'=>'-1', 'fields' => array('MAX(participant_identifier)')));
	$default_bank_number = empty($last_id[0]['MAX(participant_identifier)'])? 1: $last_id[0]['MAX(participant_identifier)']+1;
	$this->set('default_bank_number', $default_bank_number);

?>