<?php
 
 	// --------------------------------------------------------------------------------
	// Manage prostate_bank_participant_id creation
	// -------------------------------------------------------------------------------- 	
 	if($controls['MiscIdentifierControl']['autoincrement_name'] == 'prostate_bank_participant_id') {
		// Set incremented identifier if required
		if($submitted_data_validates && $is_incremented_identifier) {
			$new_identifier_value = $this->MiscIdentifierControl->getKeyIncrement($controls['MiscIdentifierControl']['autoincrement_name'], $controls['MiscIdentifierControl']['misc_identifier_format']);
			if($new_identifier_value === false) { $this->redirect( '/pages/err_clin_system_error', null, true ); }
			
			$new_identifier_value_start = substr($new_identifier_value, 0, strpos($controls['MiscIdentifierControl']['misc_identifier_format'], '%%key_increment%%'));
			$new_identifier_value_end = substr($new_identifier_value, strpos($controls['MiscIdentifierControl']['misc_identifier_format'], '%%key_increment%%'));
			$id_lenght = strlen($new_identifier_value_end);
			while($id_lenght < 4) {
				$id_lenght++;
				$new_identifier_value_end = '0'.$new_identifier_value_end;
			}			
			$this->data['MiscIdentifier']['identifier_value'] = $new_identifier_value_start.$new_identifier_value_end; 
			
			$is_incremented_identifier = false;
		}

 	} 
 
?>
