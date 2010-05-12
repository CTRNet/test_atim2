<?php
	
 	// --------------------------------------------------------------------------------
	// Check identifiers could be created more than once
	// -------------------------------------------------------------------------------- 
	if($controls['MiscIdentifierControl']['flag_is_unique']) {
 		// Check id already created
 		$is_identifier_already_created = $this->MiscIdentifier->find('count', array('conditions'=>array('MiscIdentifier.identifier_name'=>$controls['MiscIdentifierControl']['autoincrement_name'], 'MiscIdentifier.participant_id'=>$participant_id), 'recursive' => '-1'));		
 		if($is_identifier_already_created) { 
 			$this->flash( 'this identifier has already been created for your participant', '/clinicalannotation/misc_identifiers/listall/'.$participant_id ); 
 			return; 
 		}
 	} 
 	
 	// --------------------------------------------------------------------------------
	// Set data for direct autocincremented identifier creation
	// --------------------------------------------------------------------------------  	
 	if(!empty($controls['MiscIdentifierControl']['autoincrement_name'])) {
 		// Set data for direct creation
		$this->data = array();			
		$this->data['MiscIdentifier']['identifier_name'] = $controls['MiscIdentifierControl']['misc_identifier_name'];
		$this->data['MiscIdentifier']['identifier_abrv'] = $controls['MiscIdentifierControl']['misc_identifier_name_abbrev'];

		pr('manageBankParticipantNbrCreation: todo');
		//$this->manageBankParticipantNbrCreation($participant_id);

 	}

?>