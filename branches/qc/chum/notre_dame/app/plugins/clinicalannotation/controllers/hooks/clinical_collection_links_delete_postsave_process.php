<?php
 
 	// --------------------------------------------------------------------------------
	// Update participant collection sample labels
	// -------------------------------------------------------------------------------- 	
 	$collection = AppModel::atimNew('Inventorymanagement', 'Collection', true);
 	$collection->updateCollectionSampleLabels($clinical_collection_data['ClinicalCollectionLink']['collection_id'], '');

?>
