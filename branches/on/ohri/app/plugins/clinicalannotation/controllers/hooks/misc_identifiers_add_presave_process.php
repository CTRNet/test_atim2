<?php
 
 	// --------------------------------------------------------------------------------
	// Check ohri_bank_participant_id is not duplicated
	// -------------------------------------------------------------------------------- 	
	
	if($submitted_data_validates && ($controls['MiscIdentifierControl']['misc_identifier_name'] == 'ohri_bank_participant_id')) {
		if(!$this->MiscIdentifier->isDuplicatedIdentifierValue($controls['MiscIdentifierControl']['id'], $this->data['MiscIdentifier']['identifier_value'])) {
			$submitted_data_validates = false;
			$this->MiscIdentifier->validationErrors['identifier_value'] = 'this bank number has already been recorded for another participant';
		}
	}
 
?>
