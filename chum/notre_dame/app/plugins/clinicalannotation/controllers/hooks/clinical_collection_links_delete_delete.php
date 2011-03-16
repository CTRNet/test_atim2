<?php
 
 	// --------------------------------------------------------------------------------
	// Update participant collection sample labels
	// -------------------------------------------------------------------------------- 	
 	if($arr_allow_deletion['allow_deletion']) {
 		$collection = AppModel::atimNew('Inventorymanagement', 'Collection', true);
 		$collection->updateCollectionSampleLabels($clinical_collection_data['Collection']['id'], '');
	}

?>
