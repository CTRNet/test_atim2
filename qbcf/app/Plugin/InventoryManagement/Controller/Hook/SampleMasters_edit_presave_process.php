<?php

	if($sample_data['Collection']['collection_property'] != 'independent collection') {
		if($this->request->data['SampleMaster']['qbcf_tma_sample_control_code']) {
			$this->SampleMaster->validationErrors['qbcf_tma_sample_control_code'][] = __('no control data has to be set for a participant tissue');
			$submitted_data_validates = false;
		}
	} else {
		if(!$this->request->data['SampleMaster']['qbcf_tma_sample_control_code']) {
			$this->SampleMaster->validationErrors['qbcf_tma_sample_control_code'][] = __('the code of a control is required');
			$submitted_data_validates = false;
		} else {
			$conditions = array(
				'SampleMaster.id != '.$sample_master_id,
				'SampleMaster.qbcf_tma_sample_control_code' => $this->request->data['SampleMaster']['qbcf_tma_sample_control_code'],
				'SampleDetail.tissue_source' => $this->request->data['SampleDetail']['tissue_source']);
			$joins = array(array(
					'table' => 'sd_spe_tissues',
					'alias'	=> 'SampleDetail',
					'type'	=> 'INNER',
					'conditions' => array('SampleDetail.sample_master_id = SampleMaster.id')));
			if($this->SampleMaster->find('count', array('conditions' => $conditions, 'joins' => $joins, 'recursvie' => '-1'))) {
				$this->SampleMaster->validationErrors['qbcf_tma_sample_control_code'][] = __('qbcf_tma_sample_control_code and tissue_source combination should be unique');
				$submitted_data_validates = false;
			}
		}
	}
		
?>
