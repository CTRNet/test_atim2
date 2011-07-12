<?php
 
 	// --------------------------------------------------------------------------------
	// Update participant collection sample labels
	// -------------------------------------------------------------------------------- 	
 	$collection = AppModel::getInstance('Inventorymanagement', 'Collection', true);
 	$collection->updateCollectionSampleLabels($clinical_collection_data['ClinicalCollectionLink']['collection_id'], '');

?>
