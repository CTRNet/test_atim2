<?php

	$new_collection_data = $this->Collection->find('first', array('conditions' => array('id' => $collection_id), 'recursive' => '-1'));
	if($collection_data['Collection']['qcroc_collection_date'] != $new_collection_data['Collection']['qcroc_collection_date'] 
	|| $collection_data['Collection']['qcroc_collection_date_accuracy'] != $new_collection_data['Collection']['qcroc_collection_date_accuracy']) {
		$this->AliquotMaster->updateTimeRemainedInRNAlater($collection_id);
	}
		