<?php
 
 	// --------------------------------------------------------------------------------
	// Create one prostate_bank_participant_id per participant
	// -------------------------------------------------------------------------------- 	
 	if(!empty($controls['MiscIdentifierControl']['autoincrement_name'])) {
 		// Set data for direct creation
		$this->data = array();			
		$this->data['MiscIdentifier']['identifier_name'] = $controls['MiscIdentifierControl']['misc_identifier_name'];
		$this->data['MiscIdentifier']['identifier_abrv'] = $controls['MiscIdentifierControl']['misc_identifier_name_abbrev'];
 	}
 
?>
