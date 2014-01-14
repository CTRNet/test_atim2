<?php 
	
	$max_participant_identifier_res = $this->Participant->query('SELECT MAX(SUBSTRING(participant_identifier,5)) AS max_participant_identifier FROM participants WHERE deleted <> 1');
	$default_participant_identifier = '00001';
	if(!empty($max_participant_identifier_res)) {
		$default_participant_identifier = str_pad(($max_participant_identifier_res[0][0]['max_participant_identifier'] + 1), 5, '0', STR_PAD_LEFT);
	}
	$this->set('default_participant_identifier', 'CHUM'.$default_participant_identifier);
	$this->set('default_chum_transplant_project_status', 'in process');
	