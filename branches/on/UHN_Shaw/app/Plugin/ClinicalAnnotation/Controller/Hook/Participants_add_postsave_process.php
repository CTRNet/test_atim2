<?php
	
	// Create collection identifier
	$key = $this->Participant->getKeyIncrement('main_participant_id', "%%key_increment%%");
	$this->Participant->data = array();
	$this->Participant->id = $this->Participant->getLastInsertId();
	$new_identifier = array("Participant" => array("participant_identifier" => $key));
	$this->Participant->addWritableField(array('participant_identifier'));
	if (!$this->Participant->save($new_identifier)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	