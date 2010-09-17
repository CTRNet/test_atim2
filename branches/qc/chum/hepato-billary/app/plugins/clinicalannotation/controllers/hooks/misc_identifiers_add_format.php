<?php
 
 	// --------------------------------------------------------------------------------
	// Create one hepato_bil_bank_participant_id per participant
	// -------------------------------------------------------------------------------- 	
 	if($controls['MiscIdentifierControl']['autoincrement_name'] == 'hepato_bil_bank_participant_id') { 		
 		 // Set data for direct creation
		$this->data = array();			
		$this->data['MiscIdentifier']['identifier_name'] = $controls['MiscIdentifierControl']['misc_identifier_name'];
		$this->data['MiscIdentifier']['identifier_abrv'] = $controls['MiscIdentifierControl']['misc_identifier_name_abbrev'];
 	} 
 
?>
