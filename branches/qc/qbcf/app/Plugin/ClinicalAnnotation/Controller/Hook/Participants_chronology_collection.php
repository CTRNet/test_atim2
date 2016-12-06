<?php 
	
	$tmp_view_collection = $this->ViewCollection->find('first', array('conditions' => array('ViewCollection.collection_id' => $collection['Collection']['id']), 'recursive' => '-1'));
	$chronolgy_data_collection['chronology_details'] = $tmp_view_collection['ViewCollection']['qbcf_pathology_id'];
	$chronolgy_data_collection['date'] = $tmp_view_collection['ViewCollection']['collection_datetime'];
	$chronolgy_data_collection['date_accuracy'] = $tmp_view_collection['ViewCollection']['collection_datetime_accuracy'];
