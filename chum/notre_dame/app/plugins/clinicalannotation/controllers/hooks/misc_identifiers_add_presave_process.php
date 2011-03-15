<?php
 
 	// --------------------------------------------------------------------------------
	// Manage bank identifiers creation
	// -------------------------------------------------------------------------------- 	
 	if($submitted_data_validates) {
 		
		// Get Bank linked to this identifier
		$bank_model = AppModel::atimNew('Administrate', 'Bank', true);	

		$bank = $bank_model->find('first', array('conditions' => array('Bank.misc_identifier_control_id' => $misc_identifier_control_id)));
		
		if(!empty($bank)) {
 			// Create new bank identifier + update participant sample labels
			
			// Keep warning for developper
			pr('WARNING: Save process done into the hook! Check misc_identifiers_controller.php upgrade has no impact on the hook line code!');				
			
			$submitted_data_validates = false;
			
			// Get bank id
			$bank_id = $bank['Bank']['id'];
			
			// Create new identifier
			if(!$is_incremented_identifier) { 
				$this->redirect( '/pages/err_clin_system_error', null, true ); 
			}
			$new_identifier_value = $this->MiscIdentifierControl->getKeyIncrement($controls['MiscIdentifierControl']['autoincrement_name'], $controls['MiscIdentifierControl']['misc_identifier_format']);
			if($new_identifier_value === false) {
				$this->redirect( '/pages/err_clin_system_error', null, true ); 
			}
			$this->data['MiscIdentifier']['identifier_value'] = $new_identifier_value; 
			
			if($this->MiscIdentifier->save($this->data)){
	
				// Update participant sample labels of all bank collections
				$clinical_collection_link = AppModel::atimNew('Clinicalannotation', 'ClinicalCollectionLink', true);
				
				$participant_bank_collection_list = $clinical_collection_link->find('all', array('conditions' => array('ClinicalCollectionLink.participant_id' => $participant_id, 'Collection.bank_id' => $bank_id)));

				if(!empty($participant_bank_collection_list)) {
					$collection = AppModel::atimNew('Inventorymanagement', 'Collections', true);
					
					foreach($participant_bank_collection_list as $new_linked_collection){
						// Update participant collection sample labels
						$collection->updateCollectionSampleLabels($new_linked_collection['Collection']['id'], $new_identifier_value);
					}
				}
	
				$this->flash( 'your data has been saved', '/clinicalannotation/misc_identifiers/listall/'.$participant_id );
			}
		}
 	} 
?>
