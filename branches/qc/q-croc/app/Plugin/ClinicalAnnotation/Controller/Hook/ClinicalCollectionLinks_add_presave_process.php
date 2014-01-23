<?php
		
	if(empty($this->request->data['Collection']['misc_identifier_id'])) {
		$this->Collection->validationErrors['misc_identifier_id'][] = __('the patient no has to be selected');
		$submitted_data_validates = false;
	}
	
	$fields[] = 'misc_identifier_id';
	$this->Collection->addWritableField('misc_identifier_id');
