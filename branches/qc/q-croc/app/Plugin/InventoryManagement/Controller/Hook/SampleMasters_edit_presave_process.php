<?php
	
	if($is_specimen && isset($this->request->data['SpecimenDetail']['qcroc_collection_time'])
	&& !empty($this->request->data['SpecimenDetail']['qcroc_collection_time'])
	&& $sample_data['Collection']['qcroc_collection_date_accuracy'] != 'c') {
		$this->SampleMaster->validationErrors['qcroc_collection_time'][] = 'specimen collection time can not be set when collection date is estimated';
		$submitted_data_validates = false;
	}
	