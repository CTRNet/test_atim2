<?php 
	
	$bank_identification = $this->Participant->bank_identification;
	$last_id = $this->Participant->find('first', array('conditions' => array("participant_identifier LIKE '$bank_identification%'"), 'fields' => array(" MAX(CAST(REPLACE(`participant_identifier`, '$bank_identification', '') AS UNSIGNED)) AS max_val"), 'recursive'=>'-1'));
	$default_participant_identifier = $bank_identification.floor(empty($last_id[0]['max_val'])? 1: $last_id[0]['max_val']+1);
	$this->set('default_participant_identifier', $default_participant_identifier);