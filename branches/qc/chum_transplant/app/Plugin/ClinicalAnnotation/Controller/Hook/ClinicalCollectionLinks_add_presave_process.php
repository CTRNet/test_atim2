<?php 
	
	if(empty($this->request->data['Collection']['treatment_master_id'])) {
		$this->Collection->validationErrors['treatment_master_id'][] = __('the transplant linked to the collection has to be selected');
		$submitted_data_validates = false;
	}
	