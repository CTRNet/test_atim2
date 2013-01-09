<?php
	
	if($sample_control_data['SampleControl']['sample_type'] == 'tissue') {
		$collection_tissues = $this->SampleMaster->find('all', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleControl.sample_type' => 'tissue'), 'recursive' => '0', 'order' => array('SampleMaster.created DESC')));
		if(!empty($collection_tissues)) {
			$this->request->data['SpecimenDetail']['qcroc_collection_time'] = $collection_tissues[0]['SpecimenDetail']['qcroc_collection_time'];
			$this->request->data['SampleDetail']['qcroc_placed_in_stor_sol_within_5mn'] = $collection_tissues[0]['SampleDetail']['qcroc_placed_in_stor_sol_within_5mn'];
			$this->request->data['SampleDetail']['qcroc_placed_in_stor_sol_within_5mn_reason'] = $collection_tissues[0]['SampleDetail']['qcroc_placed_in_stor_sol_within_5mn_reason'];
			$this->request->data['SampleDetail']['qcroc_tissue_storage_solution'] = (sizeof($collection_tissues) > 2)? 'formalin': 'rnalater';
		}
		switch(sizeof($collection_tissues)) {
			case '0':
			case '1':
				$this->request->data['SampleDetail']['qcroc_tissue_storage_solution'] = 'rnalater';
				break;
			case '2':
				$this->request->data['SampleDetail']['qcroc_tissue_storage_solution'] = 'formalin';
				break;
			default;
		}
	}
	
	