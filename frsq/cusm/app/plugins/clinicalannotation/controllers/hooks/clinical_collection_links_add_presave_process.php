<?php
 
 	// --------------------------------------------------------------------------------
	// Manage link creation
	// -------------------------------------------------------------------------------- 
	if($submitted_data_validates && (!isset($this->data['ClinicalCollectionLink']['deleted']))) {
		// Participant will be linked to an existing collection: Manage link creation + update participant sample labels
		
		// Keep warning for developper
		pr('WARNING: Save process done into the hook! Check clinical_collections_links_controller.php upgrade has no impact on the hook line code!');				
		
		$submitted_data_validates = false;
		
		//Get selected collection data
		$selected_collection_data = array();
		foreach($collection_data as $available_collection ) {
			if($available_collection['Collection']['id'] == $this->data['ClinicalCollectionLink']['collection_id']) {
				$selected_collection_data = $available_collection;
			}
		}
		
		if(empty($selected_collection_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		
		// Launch save process
		if($this->ClinicalCollectionLink->save($this->data)) {
			App::import('Controller', 'Inventorymanagement.Collections');
			$CollectionsCtrl = new CollectionsControllerCustom();	
			$CollectionsCtrl->updateCollectionSampleLabels($selected_collection_data);
			$this->flash( 'your data has been updated','/clinicalannotation/clinical_collection_links/detail/'.$participant_id.'/'.$this->ClinicalCollectionLink->id );
		}
	}

?>
