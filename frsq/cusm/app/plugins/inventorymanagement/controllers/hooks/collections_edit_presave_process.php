<?php
 
 	// --------------------------------------------------------------------------------
	// Update collection Sample Labels
	// -------------------------------------------------------------------------------- 	
	if($submitted_data_validates && ($collection_data['Collection']['qc_cusm_visit_label'] != $this->data['Collection']['qc_cusm_visit_label'])) {
		// Collection Sample Labels have to be updated: Manage collection data record into the hook + update collection sample label
		
		// Keep warning for developper
		pr('WARNING: Save process done into the hook! Check collections_controller.php upgrade has no impact on the hook line code!');				
			
		$submitted_data_validates = false;
		
		// Save collection
		$this->Collection->id = $collection_id;
		if ($this->Collection->save($this->data)) {
			$this->data['Collection']['id'] = $collection_id;
			$this->updateCollectionSampleLabels($this->data);
			$this->atimFlash('your data has been updated', '/inventorymanagement/collections/detail/' . $collection_id);
		}		
	}
		
?>
