<?php 
	
	//Cannot be added to Participant model because participant record will be updated by system for any MiscIdentifier creation/modification
	//And there are no interest to ad control for CENTRAL BANK because data will be erased
	if(Configure::read('procure_atim_version') != 'BANK') $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	
	// Set default values
	
	$bank_identification = $this->Participant->bank_identification;
	$last_id = $this->Participant->find('first', array('conditions' => array("participant_identifier LIKE '$bank_identification%'"), 'fields' => array(" MAX(CAST(REPLACE(`participant_identifier`, '$bank_identification', '') AS UNSIGNED)) AS max_val"), 'recursive'=>'-1'));
	$new_id = empty($last_id[0]['max_val'])? '001': $last_id[0]['max_val']+1;
	$zero_to_add = 3 - strlen($new_id);
	if($zero_to_add > 0) { for($i =0; $i < $zero_to_add; $i++) $new_id = '0'.$new_id; }
	$default_participant_identifier = $bank_identification.$new_id;
	$this->set('default_participant_identifier', $default_participant_identifier);

	$this->set('default_procure_transferred_participant', 'n');