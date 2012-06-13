<?php

	$this->set('default_sex', 'f');
	
	$last_id = $this->Participant->find('first', array('recursive'=>'-1', 'fields' => array(' MAX(CAST(`participant_identifier` AS UNSIGNED)) AS max_val')));
	$default_participant_identifier = floor(empty($last_id[0]['max_val'])? 1: $last_id[0]['max_val']+1);
	$this->set('default_participant_identifier', $default_participant_identifier);
	
?>