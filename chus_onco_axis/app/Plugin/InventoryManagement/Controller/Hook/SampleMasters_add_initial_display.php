<?php 
		
	if($sample_control_data['SampleControl']['sample_type'] == 'tissue') {
		
		//--------------------------------------------------------------------------------
		//  TISSUE
		//--------------------------------------------------------------------------------
		
		$last_tissue_modified = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.sample_control_id' => $sample_control_data['SampleControl']['id'], 'SampleMaster.collection_id' => $collection_id), 'orders' => array('SampleMaster.modified DESC')));
		if($last_tissue_modified) {
			$this->request->data = $last_tissue_modified;
		} else {
			$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id), 'recursive' => '-1'));
			$this->request->data['SpecimenDetail']['reception_datetime'] = $collection_data['Collection']['collection_datetime'];
			$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = in_array($collection_data['Collection']['collection_datetime_accuracy'], array('h', 'mn', 'c'))? 'h' : $collection_data['Collection']['collection_datetime_accuracy'];
			if($collection_data['Collection']['collection_datetime_accuracy'] == 'c' && preg_match('/^(.*)\ (.*)$/', $collection_data['Collection']['collection_datetime'], $matches)) $this->request->data['SampleDetail']['chus_ischemia_time'] = $matches[2];
		}
		
	} else {
		
	}
		
?>