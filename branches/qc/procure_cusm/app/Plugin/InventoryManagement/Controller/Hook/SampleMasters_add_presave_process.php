<?php
	
	//CHUS -- HOOK
	if ($is_specimen  && false) {
		if($collection_data['Collection']['procure_chus_collection_specimen_sample_control_id'] != $this->request->data['SampleMaster']['sample_control_id']) {
			$this->SampleMaster->validationErrors['sample_control_id'][] = 'there is a mismatch between the specimen type assigned to collection and the created specimen';
			$submitted_data_validates = false;
		}
	}
	
?>