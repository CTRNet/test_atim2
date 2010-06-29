<?php
 
 	// --------------------------------------------------------------------------------
	// Update participant collection sample labels
	// -------------------------------------------------------------------------------- 	
 	if($arr_allow_deletion['allow_deletion']) {
 		App::import('Controller', 'Inventorymanagement.Collections');
		$CollectionsCtrl = new CollectionsControllerCustom();	
			
		// Update participant collection sample labels
		$CollectionsCtrl->updateCollectionSampleLabels($clinical_collection_data['Collection']['id'], '');
	}

?>
