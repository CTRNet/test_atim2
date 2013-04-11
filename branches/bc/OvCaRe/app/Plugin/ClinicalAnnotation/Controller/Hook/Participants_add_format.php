<?php

	// --------------------------------------------------------------------------------
	// Generate default VOA#
	// -------------------------------------------------------------------------------- 
	$last_id = $this->Participant->find('first', array('recursive'=>'-1', 'fields' => array('MAX(participant_identifier)')));
	$default_voa_nbr = empty($last_id[0]['MAX(participant_identifier)'])? 1: $last_id[0]['MAX(participant_identifier)']+1;
	$this->set('default_voa_nbr', $default_voa_nbr);

?>