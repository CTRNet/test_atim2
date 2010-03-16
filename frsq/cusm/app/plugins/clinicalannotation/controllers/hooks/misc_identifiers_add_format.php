<?php
 
 	// --------------------------------------------------------------------------------
	// Create one prostate_bank_participant_id per participant
	// -------------------------------------------------------------------------------- 	
 	if($controls['MiscIdentifierControl']['autoincrement_name'] == 'prostate_bank_participant_id') {
 		// Check id already created
 		$is_identifier_already_created = $this->MiscIdentifier->find('count', array('conditions'=>array('MiscIdentifier.identifier_name'=>$controls['MiscIdentifierControl']['autoincrement_name'], 'MiscIdentifier.participant_id'=>$participant_id), 'recursive' => '-1'));		
 		if($is_identifier_already_created) { 
 			$this->flash( 'this identifier has already been created for your participant', '/clinicalannotation/misc_identifiers/listall/'.$participant_id ); 
 			return; 
 		}
 		
 		// Set data for direct creation
		$this->data = array();			
		$this->data['MiscIdentifier']['identifier_name'] = $controls['MiscIdentifierControl']['misc_identifier_name'];
		$this->data['MiscIdentifier']['identifier_abrv'] = $controls['MiscIdentifierControl']['misc_identifier_name_abbrev'];
 	} 
 
?>
