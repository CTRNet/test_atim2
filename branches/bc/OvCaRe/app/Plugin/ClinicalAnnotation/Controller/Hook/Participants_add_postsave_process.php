<?php
	
	// --------------------------------------------------------------------------------
	// Record Misc Identifier Value
	// --------------------------------------------------------------------------------	

	foreach($this->request->data['0'] as $field => $value) {
		if(preg_match('/^(ovcare_.+)_misc_identifier_control_id$/', $field, $matches)) {
			$identifier_value_field_key = $matches[1];
			$misc_identifier_data = array();
			$misc_identifier_data['participant_id'] = $this->Participant->getLastInsertID();
			$misc_identifier_data['identifier_value'] = $this->request->data['0'][$identifier_value_field_key.'_identifier_value'];
			$misc_identifier_data['misc_identifier_control_id'] = $this->request->data['0'][$identifier_value_field_key.'_misc_identifier_control_id'];
			$misc_identifier_data['flag_unique'] = $this->request->data['0'][$identifier_value_field_key.'_flag_unique'];
			$this->MiscIdentifier->check_writable_fields = false;
			$this->MiscIdentifier->data = array();
			$this->MiscIdentifier->id = null;		
			$this->MiscIdentifier->save($misc_identifier_data, false);
		}
	}
	
?>