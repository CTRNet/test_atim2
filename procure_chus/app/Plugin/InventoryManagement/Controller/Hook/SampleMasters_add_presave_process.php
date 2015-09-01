<?php 
	
	$this->request->data['SampleMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
	$this->SampleMaster->addWritableField(array('procure_created_by_bank'));
	
	// PROCURE CHUS
	if($is_specimen) {
		if($collection_data['Collection']['procure_chus_collection_specimen_sample_control_id'] != $this->request->data['SampleMaster']['sample_control_id']) {
			$this->SampleMaster->validationErrors['sample_control_id'][] = 'there is a mismatch between the specimen type assigned to collection and the created specimen';
			$submitted_data_validates = false;
		}
	}
	// END PROCURE CHUS
	