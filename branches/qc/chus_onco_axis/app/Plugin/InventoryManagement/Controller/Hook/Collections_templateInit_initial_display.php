<?php 
	
	$tmp_collection_data = $this->Collection->find('first' , array('conditions' => array('Collection.id' => $collection_id), 'recursive' => '-1'));
	$this->request->data['SpecimenDetail']['reception_datetime'] = $tmp_collection_data['Collection']['collection_datetime'];
	$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $tmp_collection_data['Collection']['collection_datetime_accuracy'];