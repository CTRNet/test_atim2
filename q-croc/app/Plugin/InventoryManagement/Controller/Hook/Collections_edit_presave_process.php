<?php
	
	if(!strlen($this->request->data['Collection']['qcroc_collection_date']['day'])) {
		$error = $this->SampleMaster->find('count', array('conditions' => array('Collection.id' => $collection_id, "SpecimenDetail.qcroc_collection_time != ''"), 'recursive' => '0'));	
		if($error) {
			$this->AliquotMaster->validationErrors['qcroc_collection_date'][] = 'collection date can not be estimated when the time is set for at least one specimen';
			$submitted_data_validates = false;
		}
	}
	
	if(!strlen($this->request->data['Collection']['qcroc_biopsy_type'].$this->request->data['Collection']['qcroc_banking_nbr'])) {
		$this->AliquotMaster->validationErrors['qcroc_biopsy_type'][] = 'either banking # or biopsy type fields has to be entered';
		$submitted_data_validates = false;
	} else if(strlen($this->request->data['Collection']['qcroc_biopsy_type'].$this->request->data['Collection']['qcroc_radiologist'].$this->request->data['Collection']['qcroc_coordinator']) && strlen($this->request->data['Collection']['qcroc_banking_nbr'])) {
		$this->AliquotMaster->validationErrors['qcroc_biopsy_type'][] = 'you can not enter both blood collection fields and biopsy fields for the same collection';
		$submitted_data_validates = false;
	} else {
		//Check sample
		$this->SampleMaster->unbindModel(array('belongsTo' => array('Collection'),'hasOne' => array('SpecimenDetail','DerivativeDetail'),'hasMany' => array('AliquotMaster')));
		$qcroc_collection_sample_type = $this->SampleMaster->find('all', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleControl.sample_category' => 'specimen'), 'fields' => array('DISTINCT SampleControl.sample_type'), 'recursive' => '0'));
		if($qcroc_collection_sample_type) {
			if((strlen($this->request->data['Collection']['qcroc_biopsy_type']) && $qcroc_collection_sample_type['0']['SampleControl']['sample_type'] != 'tissue')
			|| (strlen($this->request->data['Collection']['qcroc_banking_nbr']) && $qcroc_collection_sample_type['0']['SampleControl']['sample_type'] != 'blood')) {
				$this->AliquotMaster->validationErrors['qcroc_biopsy_type'][] = 'the entered collection fields does not match the collection samples';
				$submitted_data_validates = false;
			}	
		}
	}
	