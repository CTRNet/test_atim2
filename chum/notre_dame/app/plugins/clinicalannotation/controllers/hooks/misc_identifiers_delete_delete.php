<?php
 
 	// --------------------------------------------------------------------------------
	// Update participant collection sample labels
	// -------------------------------------------------------------------------------- 	
 	if($arr_allow_deletion['allow_deletion']) {
			
 		// Get Bank linked to the deleted identifier
		App::import('Model', 'Administrate.Bank');
		$Bank = new Bank();	

		$banks = $Bank->find('first', array('conditions' => array('Bank.misc_identifier_control_id' => $misc_identifier_data['MiscIdentifier']['misc_identifier_control_id'])));
		
		if(!empty($banks)) {
 			// Bank identifier: CUpdate participant sample labels of all bank collections
			
			// Get bank id
			if(!isset($banks['Bank']['id'])) { $this->redirect( '/pages/err_clin_system_error', null, true ); }
			$bank_id = $banks['Bank']['id'];
			
			// Launch sample label upgrade process	
			App::import('Model', 'Clinicalannotation.ClinicalCollectionLink');
			$ClinicalCollectionLink = new ClinicalCollectionLink();	
			
			$participant_bank_collection_list = $ClinicalCollectionLink->find('all', array('conditions' => array('ClinicalCollectionLink.participant_id' => $participant_id, 'Collection.bank_id' => $bank_id)));
			if(!empty($participant_bank_collection_list)) {
				App::import('Controller', 'Inventorymanagement.Collections');
				$CollectionsCtrl = new CollectionsControllerCustom();	
				
				foreach($participant_bank_collection_list as $new_linked_collection) {
					// Update participant collection sample labels
					$CollectionsCtrl->updateCollectionSampleLabels($new_linked_collection['Collection']['id'], '');
				}
			}	
		}
	}

?>
