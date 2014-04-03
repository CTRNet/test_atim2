<?php

	if($is_specimen) {
		$ld_lymph_specimen_number = $this->request->data['SampleMaster']['ld_lymph_specimen_number'];
		$is_duplicated = $this->SampleMaster->find('count', array('conditions' => array('SampleMaster.ld_lymph_specimen_number' => $ld_lymph_specimen_number), 'recursive' => '-1'));	
		if($is_duplicated) {
			$submitted_data_validates = false;
			$this->SampleMaster->validationErrors['ld_lymph_specimen_number'] = 'the specimen number should be unique';	
		}
	} else {
		$this->request->data['SampleMaster']['ld_lymph_specimen_number'] = $parent_sample_data['SampleMaster']['ld_lymph_specimen_number'];
		$this->SampleMaster->addWritableField(array('ld_lymph_specimen_number'));
	}
	