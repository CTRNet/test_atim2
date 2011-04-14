<?php
 
 	// --------------------------------------------------------------------------------
	// Update participant collection sample labels
	// -------------------------------------------------------------------------------- 
	if(!empty($this->data['ClinicalCollectionLink']['collection_id'])) {
		// Participant will be linked to an existing collection
		$collection = AppModel::atimNew('Inventorymanagement', 'Collection', true);
		$collection->updateCollectionSampleLabels($this->data['ClinicalCollectionLink']['collection_id']);
	}

?>
