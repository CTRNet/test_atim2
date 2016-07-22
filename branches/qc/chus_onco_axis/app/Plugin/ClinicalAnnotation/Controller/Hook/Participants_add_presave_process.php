<?php
	
$misc_identifiers_to_create = array();
if(array_key_exists('0', $this->request->data)) {
	foreach(array('chus_hospital_card_number', 'chus_health_insurance_number' ) as $field) {
		$misc_identifier_name = str_replace(array('chus_', '_'), array('', ' '), $field);
		if(array_key_exists($field, $this->request->data['0']) && strlen($this->request->data['0'][$field])) {
			$controls = $this->MiscIdentifierControl->find('first', array('conditions' => array('misc_identifier_name' => $misc_identifier_name)));
			if(!$controls) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			if(!empty($controls['MiscIdentifierControl']['autoincrement_name'])) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			// Model validates()
			$new_identifier = array(
				'MiscIdentifier' => array(
					'participant_id' => null,
					'misc_identifier_control_id' => $controls['MiscIdentifierControl']['id'],
					'identifier_value' => $this->request->data['0'][$field]));
			$this->MiscIdentifier->set($new_identifier);
			if(!$this->MiscIdentifier->validates()) $submitted_data_validates = false;
			$new_identifier = $this->MiscIdentifier->data;
			// Flag unique validation
			$new_identifier['MiscIdentifier']['flag_unique'] = $controls['MiscIdentifierControl']['flag_unique'];
			if($controls['MiscIdentifierControl']['flag_unique']){
				if($this->MiscIdentifier->find('first', array('conditions' => array('misc_identifier_control_id' => $new_identifier['MiscIdentifier']['misc_identifier_control_id'], 'identifier_value' => $new_identifier['MiscIdentifier']['identifier_value'])))){
					$submitted_data_validates = false;
					$this->MiscIdentifier->validationErrors['identifier_value'][] = __('this field must be unique');
				}
			}
			// Set data
			$misc_identifiers_to_create[] = $new_identifier;
			foreach($this->MiscIdentifier->validationErrors as $new_errors) {
				foreach($new_errors as $new_error) {
					$this->Participant->validationErrors[$field][] = __($new_error).' ('.__($controls['MiscIdentifierControl']['misc_identifier_name']).')';
				}
			}
			$this->MiscIdentifier->validationErrors = array();
		}
	}
}
