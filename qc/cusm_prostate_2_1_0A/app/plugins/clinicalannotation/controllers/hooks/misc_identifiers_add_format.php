<?php
 
 	// --------------------------------------------------------------------------------
	// Set data to create directly auto-incremented identifier
	// -------------------------------------------------------------------------------- 	
 	if($is_incremented_identifier) {
 		// Set data for direct creation
		$this->data = array();			
		$this->data['MiscIdentifier']['identifier_name'] = $controls['MiscIdentifierControl']['misc_identifier_name'];
		$this->data['MiscIdentifier']['identifier_abrv'] = $controls['MiscIdentifierControl']['misc_identifier_name_abbrev'];
 	}
 
?>
