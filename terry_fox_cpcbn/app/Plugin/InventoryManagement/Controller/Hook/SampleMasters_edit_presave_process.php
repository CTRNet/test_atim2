<?php

	if($sample_data['Collection']['collection_property'] != 'independent collection') {
		//Participant Tissue: Prostate tissue (not a control)
		if($this->request->data['SampleDetail']['tissue_source'] != 'prostate') {
			$this->SampleMaster->validationErrors['tissue_source'][] = __('tissue source of a participant tissue should be a prostate');
			$submitted_data_validates = false;
		}
		if($this->request->data['SampleMaster']['qc_tf_tma_sample_control_code']) {
			$this->SampleMaster->validationErrors['qc_tf_tma_sample_control_code'][] = __('no control data has to be set for a participant tissue');
			$submitted_data_validates = false;
		}
		if($this->request->data['SampleMaster']['qc_tf_tma_sample_control_bank_id']) {
			$this->SampleMaster->validationErrors['qc_tf_tma_sample_control_bank_id'][] = __('no control data has to be set for a participant tissue');
			$submitted_data_validates = false;
		}
	} else {
		if(!$this->request->data['SampleMaster']['qc_tf_tma_sample_control_code']) {
			$this->SampleMaster->validationErrors['qc_tf_tma_sample_control_code'][] = __('the code of a control is required');
			$submitted_data_validates = false;
		}
	}
		
?>
