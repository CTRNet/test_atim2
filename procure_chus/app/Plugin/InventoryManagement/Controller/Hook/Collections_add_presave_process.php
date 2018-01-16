<?php 
	
	if(($collection_data && !$collection_data['Collection']['participant_id'])
	|| (!$collection_data && !isset($this->request->data['Collection']['participant_id']))){
		$submitted_data_validates = false;
		$this->Collection->validationErrors['participant_id'][] = __('a created collection should be linked to a participant');
	}

	$this->request->data['Collection']['procure_collected_by_bank'] = Configure::read('procure_bank_id');
	$this->Collection->addWritableField(array('procure_collected_by_bank'));
	
	// PROCURE CHUS
	if($collection_data) {
		$this->Collection->writable_fields_mode = 'add';
		$this->Collection->addWritableField('procure_chus_collection_specimen_sample_control_id');
	}
	// END PROCURE CHUS
	