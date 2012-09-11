<?php
	
	$updated_collection_data = $this->Collection->find('first', array('conditions' =>array('Collection.id' => $collection_id), 'recursive' => '-1'));
	$add_warning = false;
	$collections_specimens = $this->SampleMaster->find('all', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleControl.sample_category' => 'specimen'), 'recursive' => '0'));
	foreach($collections_specimens as $new_sample) {
		if(!$this->SampleMaster->validateChusCollectionDates($updated_collection_data, $new_sample)) $add_warning = true;
	}
	if($add_warning) AppController::addWarningMsg(__('at least one specimen will have a collection date different than the new date of the collection'));
	