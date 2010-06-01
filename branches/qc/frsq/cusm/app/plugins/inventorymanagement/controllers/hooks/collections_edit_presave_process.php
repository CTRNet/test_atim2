<?php
 
 	// --------------------------------------------------------------------------------
	// Update collection Sample Labels
	// -------------------------------------------------------------------------------- 	
	if($collection_data['Collection']['qc_cusm_visit_label'] != $this->data['Collection']['qc_cusm_visit_label']) {
		// Collection Sample Labels have to be updated: Manage collection data record into the hook
		$submitted_data_validates = false;
		
		// Save collection
		$this->Collection->id = $collection_id;
		if ($this->Collection->save($this->data)) {
			$this->data['Collection']['id'] = $collection_id;
			$this->updateCollectionSampleLabels($this->data);
			$this->flash('your data has been updated', '/inventorymanagement/collections/detail/' . $collection_id);
		}		
	}
		
?>
