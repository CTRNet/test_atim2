<?php
 
 	// --------------------------------------------------------------------------------
	// Check ohri_bank_participant_id is not duplicated
	// -------------------------------------------------------------------------------- 	
	
	if($submitted_data_validates 
	&& ($misc_identifier_data['MiscIdentifierControl']['misc_identifier_name'] == 'ohri_bank_participant_id')
	&& ($misc_identifier_data['MiscIdentifier']['identifier_value'] != $this->data['MiscIdentifier']['identifier_value'])) {
		if(!$this->MiscIdentifier->isDuplicatedIdentifierValue($misc_identifier_data['MiscIdentifierControl']['id'], $this->data['MiscIdentifier']['identifier_value'])) {
			$submitted_data_validates = false;
			$this->MiscIdentifier->validationErrors['identifier_value'] = 'this bank number has already been recorded for another participant';
		}
	}
 
?>
