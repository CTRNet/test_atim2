<?php
	
	if($sample_control_data['SampleControl']['sample_type'] == 'tissue') {
		$collection_tissues = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleControl.sample_type' => 'tissue'), 'recursive' => '0', 'order' => array('SampleMaster.created DESC')));
		if(!empty($collection_tissues)) {
			$this->request->data['SpecimenDetail']['qcroc_collection_time'] = $collection_tissues['SpecimenDetail']['qcroc_collection_time'];
			$this->request->data['SampleDetail']['qcroc_placed_in_stor_sol_within_5mn'] = $collection_tissues['SampleDetail']['qcroc_placed_in_stor_sol_within_5mn'];
			$this->request->data['SampleDetail']['qcroc_placed_in_stor_sol_within_5mn_reason'] = $collection_tissues['SampleDetail']['qcroc_placed_in_stor_sol_within_5mn_reason'];
		}
	}
	