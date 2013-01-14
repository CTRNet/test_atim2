<?php
	
	if(!strlen($this->request->data['Collection']['qcroc_collection_date']['day'])) {
		$error = $this->SampleMaster->find('count', array('conditions' => array('Collection.id' => $collection_id, "SpecimenDetail.qcroc_collection_time != ''"), 'recursive' => '0'));	
		if($error) {
			$this->AliquotMaster->validationErrors['qcroc_collection_date'][] = 'collection date can not be estimated when the time is set for at least one specimen';
			$submitted_data_validates = false;
		}
	}
	