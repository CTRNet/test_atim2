<?php
 
 	// --------------------------------------------------------------------------------
	// Update participant collection sample labels
	// -------------------------------------------------------------------------------- 	
 	if($arr_allow_deletion['allow_deletion']) {
			
 		// Get Bank linked to the deleted identifier
		$bank_model = AppModel::atimNew('Administrate', 'Bank', true);	

		$bank = $bank_model->find('first', array('conditions' => array('Bank.misc_identifier_control_id' => $misc_identifier_data['MiscIdentifier']['misc_identifier_control_id'])));
		
		if(!empty($bank)) {
 			// Bank identifier: CUpdate participant sample labels of all bank collections
			
			// Get bank id
			$bank_id = $bank['Bank']['id'];
			
			// Launch sample label upgrade process	
			$clinical_collection_link = AppModel::atimNew('Clinicalannotation', 'ClinicalCollectionLink', true);	
			
			$participant_bank_collection_list = $clinical_collection_link->find('all', array('conditions' => array('ClinicalCollectionLink.participant_id' => $participant_id, 'Collection.bank_id' => $bank_id)));
			if(!empty($participant_bank_collection_list)) {
				$collection = AppModel::atimNew('Inventorymanagement', 'Collections', true);
				
				foreach($participant_bank_collection_list as $new_linked_collection) {
					// Update participant collection sample labels
					$collection->updateCollectionSampleLabels($new_linked_collection['Collection']['id'], '');
				}
			}	
		}
	}

?>
