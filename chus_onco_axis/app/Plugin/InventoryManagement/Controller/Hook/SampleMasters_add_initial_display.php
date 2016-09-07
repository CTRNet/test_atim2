<?php 
		
	switch($sample_control_data['SampleControl']['sample_type']) {
		case 'tissue':
			$last_sample_modified = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.sample_control_id' => $sample_control_data['SampleControl']['id'], 'SampleMaster.collection_id' => $collection_id), 'orders' => array('SampleMaster.modified DESC')));
			if($last_sample_modified) {
				$this->request->data = $last_sample_modified;
				unset($this->request->data['SampleDetail']);
				$this->request->data['SampleDetail']['pathology_reception_datetime'] = $last_sample_modified['SampleDetail']['pathology_reception_datetime'];
				$this->request->data['SampleDetail']['pathology_reception_datetime_accuracy'] = $last_sample_modified['SampleDetail']['pathology_reception_datetime_accuracy'];
			} else {
				$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id), 'recursive' => '-1'));
				$this->request->data['SpecimenDetail']['reception_datetime'] = $collection_data['Collection']['collection_datetime'];
				$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = in_array($collection_data['Collection']['collection_datetime_accuracy'], array('i', 'c'))? 'h' : $collection_data['Collection']['collection_datetime_accuracy'];
				$this->request->data['SampleDetail']['pathology_reception_datetime'] = $this->request->data['SpecimenDetail']['reception_datetime'];
				$this->request->data['SampleDetail']['pathology_reception_datetime_accuracy'] = $this->request->data['SpecimenDetail']['reception_datetime_accuracy'];
			}
			break;
		case 'blood':
			$last_sample_modified = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.sample_control_id' => $sample_control_data['SampleControl']['id'], 'SampleMaster.collection_id' => $collection_id), 'orders' => array('SampleMaster.modified DESC')));
			if($last_sample_modified) {
				$this->request->data = $last_sample_modified;
				unset($this->request->data['SampleDetail']);
			} else {
				$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id), 'recursive' => '-1'));
				$this->request->data['SpecimenDetail']['reception_datetime'] = $collection_data['Collection']['collection_datetime'];
				$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = in_array($collection_data['Collection']['collection_datetime_accuracy'], array('i', 'c'))? 'h' : $collection_data['Collection']['collection_datetime_accuracy'];
			}
			break;
		case 'serum':
		case 'plasma':
		case 'buffy coat':
			$sample_control_ids = $this->SampleControl->find('list', array('fields' => array('SampleControl.id'), 'conditions' => array("SampleControl.sample_type" => array('serum', 'plasma', 'buffy coat')), 'recursive' => -1));
			$last_sample_modified = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.sample_control_id' => $sample_control_ids, 'SampleMaster.collection_id' => $collection_id), 'orders' => array('SampleMaster.modified DESC')));
			if($last_sample_modified) {
				$this->request->data = $last_sample_modified;
			} else {
				$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id), 'recursive' => '-1'));
				$this->request->data['DerivativeDetail']['creation_datetime'] = $collection_data['Collection']['collection_datetime'];
				$this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = in_array($collection_data['Collection']['collection_datetime_accuracy'], array('i', 'c'))? 'h' : $collection_data['Collection']['collection_datetime_accuracy'];
			}
			break;
	}
		
?>