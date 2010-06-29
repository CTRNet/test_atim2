<?php
 
 	// --------------------------------------------------------------------------------
	// Update collection Sample Labels
	// -------------------------------------------------------------------------------- 	
	if($submitted_data_validates && $collection_data['Collection']['bank_id'] != $this->data['Collection']['bank_id']) {
		// Collection Sample Labels have to be updated: Manage collection data record into the hook + update collection sample label
		
		// Keep warning for developper
		pr('WARNING: Save process done into the hook! Check collections_controller.php upgrade has no impact on the hook line code!');				
			
		$submitted_data_validates = false;
		
		// Save collection
		$this->Collection->id = $collection_id;
		if ($this->Collection->save($this->data)) {
			$this->updateCollectionSampleLabels($collection_id);
			$this->flash('your data has been updated', '/inventorymanagement/collections/detail/' . $collection_id);
		}		
	}
		
?>
