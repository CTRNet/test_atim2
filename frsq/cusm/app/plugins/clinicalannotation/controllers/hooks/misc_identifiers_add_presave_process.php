<?php
 
 	// --------------------------------------------------------------------------------
	// Manage prostate_bank_participant_id creation
	// -------------------------------------------------------------------------------- 	
	if($submitted_data_validates && ($controls['MiscIdentifierControl']['autoincrement_name'] == 'prostate_bank_participant_id')) {
		// Create new bank identifier + update participant sample labels
		
		// Keep warning for developper
		pr('WARNING: Save process done into the hook! Check misc_identifiers_links_controller.php upgrade has no impact on the hook line code!');				
		
		$submitted_data_validates = false;
		
		// Create new identifier
		if(!$is_incremented_identifier) { $this->redirect( '/pages/err_clin_system_error', null, true ); }
		$new_identifier_value = $this->MiscIdentifierControl->getKeyIncrement($controls['MiscIdentifierControl']['autoincrement_name'], $controls['MiscIdentifierControl']['misc_identifier_format']);
		if($new_identifier_value === false) { $this->redirect( '/pages/err_clin_system_error', null, true ); }
		
		$new_identifier_value_start = substr($new_identifier_value, 0, strpos($controls['MiscIdentifierControl']['misc_identifier_format'], '%%key_increment%%'));
		$new_identifier_value_end = substr($new_identifier_value, strpos($controls['MiscIdentifierControl']['misc_identifier_format'], '%%key_increment%%'));
		$id_lenght = strlen($new_identifier_value_end);
		while($id_lenght < 4) {
			$id_lenght++;
			$new_identifier_value_end = '0'.$new_identifier_value_end;
		}		
		$new_identifier_value = $new_identifier_value_start.$new_identifier_value_end;	
		$this->data['MiscIdentifier']['identifier_value'] = $new_identifier_value; 
		
		if ( $this->MiscIdentifier->save($this->data) ) {
			// Update participant collection sample labels
			App::import('Model', 'Clinicalannotation.ClinicalCollectionLink');
			$ClinicalCollectionLink = new ClinicalCollectionLink();	
			
			$participant_collection_list = $ClinicalCollectionLink->find('all', array('conditions' => array('ClinicalCollectionLink.participant_id' => $participant_id)));
			if(!empty($participant_collection_list)) {
				App::import('Controller', 'Inventorymanagement.Collections');
				$CollectionsCtrl = new CollectionsControllerCustom();	
				
				foreach($participant_collection_list as $new_linked_collection) {
					// Update participant collection sample labels
					$CollectionsCtrl->updateCollectionSampleLabels($new_linked_collection, $new_identifier_value);
				}
			}

			$this->atimFlash( 'your data has been saved','/clinicalannotation/misc_identifiers/detail/'.$participant_id.'/'.$this->MiscIdentifier->id );
		}
	}
 
?>
