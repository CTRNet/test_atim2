<?php
 
 	// --------------------------------------------------------------------------------
	// Update participant collection sample labels
	// -------------------------------------------------------------------------------- 	
 	if($arr_allow_deletion['allow_deletion']) {
 		App::import('Controller', 'Inventorymanagement.Collections');
 		$collection_controller =  new CollectionsControllerCustom();	
			
		// Update participant collection sample labels
		$collection_controller->updateCollectionSampleLabels($clinical_collection_data['Collection']['id'], '');
	}

?>
