<?php
	
	// --------------------------------------------------------------------------------
	// Save Participant Identifier
	// -------------------------------------------------------------------------------- 
	$query_to_update = "UPDATE participants SET participants.participant_identifier = CONCAT('p#',participants.id) WHERE participants.id = ".$this->Participant->id.";";
	$this->Participant->tryCatchQuery($query_to_update);
	$this->Participant->tryCatchQuery(str_replace("participants", "participants_revs", $query_to_update));
	
	// --------------------------------------------------------------------------------
	// Save other participant identifiers
	// -------------------------------------------------------------------------------- 
	$this->MiscIdentifier->addWritableField(array('participant_id', 'misc_identifier_control_id', 'identifier_value', 'flag_unique'));
	foreach($misc_identifiers_to_create as $new_identifier_to_create) {
		$new_identifier_to_create['MiscIdentifier']['participant_id'] = $this->Participant->id;
		$this->MiscIdentifier->id = null;
		$this->MiscIdentifier->data = array();
		if (!$this->MiscIdentifier->save($new_identifier_to_create, false)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	}
