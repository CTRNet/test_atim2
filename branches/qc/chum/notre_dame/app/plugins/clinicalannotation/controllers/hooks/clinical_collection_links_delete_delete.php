<?php
 
 	// --------------------------------------------------------------------------------
	// Update participant collection sample labels
	// -------------------------------------------------------------------------------- 	
 	if($arr_allow_deletion['allow_deletion']) {
 		$collection = AppModel::atimNew('Inventorymanagement', 'Collections', true);	
			
		// Update participant collection sample labels
		$collection->updateCollectionSampleLabels($clinical_collection_data['Collection']['id'], '');
	}

?>
