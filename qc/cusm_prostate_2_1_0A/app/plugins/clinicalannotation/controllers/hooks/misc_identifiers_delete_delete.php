<?php
 
 	// --------------------------------------------------------------------------------
	// Update participant collection sample labels
	// -------------------------------------------------------------------------------- 	
 	if($arr_allow_deletion['allow_deletion']) {
		App::import('Model', 'Clinicalannotation.ClinicalCollectionLink');
		$ClinicalCollectionLink = new ClinicalCollectionLink();	
		
		$participant_collection_list = $ClinicalCollectionLink->find('all', array('conditions' => array('ClinicalCollectionLink.participant_id' => $participant_id)));
		if(!empty($participant_collection_list)) {
			App::import('Controller', 'Inventorymanagement.Collections');
			$CollectionsCtrl = new CollectionsControllerCustom();	
			
			foreach($participant_collection_list as $new_linked_collection) {
				// Update participant collection sample labels
				$CollectionsCtrl->updateCollectionSampleLabels($new_linked_collection, '');
			}
		}		
	}

?>
