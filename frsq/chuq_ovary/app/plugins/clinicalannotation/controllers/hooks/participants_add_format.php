<?php

	// --------------------------------------------------------------------------------
	// Generate default NS
	// -------------------------------------------------------------------------------- 
	$last_id = $this->Participant->find('first', array('recursive'=>'-1', 'fields' => array('MAX(participant_identifier)')));
	$default_NS = empty($last_id[0]['MAX(participant_identifier)'])? 1: $last_id[0]['MAX(participant_identifier)']+1;
	$this->set('default_NS', $default_NS);

?>