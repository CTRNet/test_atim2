<?php
 
 	// --------------------------------------------------------------------------------
	// Create one hepato_bil_bank_participant_id per participant
	// -------------------------------------------------------------------------------- 	
 	if($controls['MiscIdentifierControl']['autoincrement_name'] == 'hepato_bil_bank_participant_id') {
 		$is_identifier_already_created = $this->MiscIdentifier->find('count', array('conditions'=>array('MiscIdentifier.identifier_name'=>$controls['MiscIdentifierControl']['autoincrement_name'], 'MiscIdentifier.participant_id'=>$participant_id), 'recursive' => '-1'));		
 		if($is_identifier_already_created) { $this->flash( 'this identifier has already been created for your participant', '/clinicalannotation/misc_identifiers/listall/'.$participant_id ); return; }
 	} 
 
?>
