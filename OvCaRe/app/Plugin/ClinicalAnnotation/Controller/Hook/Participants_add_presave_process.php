<?php
	
	// --------------------------------------------------------------------------------
	// Get next Participant Identifier
	// -------------------------------------------------------------------------------- 
	$this->Participant->addWritableField(array('participant_identifier'));
	$last_participant_identifier = $this->Participant->find('first', array('recursive'=>'-1', 'fields' => array('MAX(participant_identifier)')));
	$next_participant_identifier = empty($last_participant_identifier[0]['MAX(participant_identifier)'])? 1: $last_participant_identifier[0]['MAX(participant_identifier)']+1;
	$this->request->data['Participant']['participant_identifier'] = $next_participant_identifier;
	
	// --------------------------------------------------------------------------------
	// Validate Misc Identifier Value
	// --------------------------------------------------------------------------------	
	
	$misc_identifier_controls_tmp = $this->MiscIdentifierControl->find('all', array('conditions' => array('MiscIdentifierControl.misc_identifier_name' => array('medical record number', 'personal health number', 'bcca number'))));
	$misc_identifier_controls = array();
	foreach($misc_identifier_controls_tmp as $key => $misc_identifier_control) {
		$misc_identifier_controls[$misc_identifier_control['MiscIdentifierControl']['misc_identifier_name']] = array($misc_identifier_control['MiscIdentifierControl']['id'], $misc_identifier_control['MiscIdentifierControl']['flag_unique']);
	}
	foreach($this->request->data['0'] as $field => $identifier_value) {
		if(strlen($identifier_value) && preg_match('/^ovcare_(.+)_identifier_value$/', $field, $matches)) {
			$misc_identifier_name = str_replace('_',' ', $matches[1]);
			list($misc_identifier_control_id, $misc_identifier_flag_unique) = $misc_identifier_controls[$misc_identifier_name];
			if(!$misc_identifier_control_id) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); ;
			if(strlen($identifier_value) > 50) {
				$this->Participant->validationErrors[$field][] = __("the string length must not exceed %d characters", 50).' ('.__($misc_identifier_name).')';
				$submitted_data_validates = false;
			}
			if($this->MiscIdentifier->find('count', array('conditions' => array('MiscIdentifier.misc_identifier_control_id' => $misc_identifier_control_id, 'MiscIdentifier.identifier_value' => $identifier_value)))) {
				$this->Participant->validationErrors[$field][] = __('this field must be unique').' ('.__($misc_identifier_name).')';
				$submitted_data_validates = false;
			}
			$this->request->data['0'][str_replace('_identifier_value', '_misc_identifier_control_id', $field)] = $misc_identifier_control_id;
			$this->request->data['0'][str_replace('_identifier_value', '_flag_unique', $field)] = $misc_identifier_flag_unique;
		}
	}
	
?>