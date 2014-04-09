<?php
	
	if($dx_ctrl['DiagnosisControl']['controls_type'] == 'ovary') {
		$this->request->data['DiagnosisMaster']['uhn_site'] = 'female genital-ovary';
		$this->DiagnosisMaster->addWritableField(array('uhn_site'));		
	} else if($dx_ctrl['DiagnosisControl']['controls_type'] == 'endometrium') {
		$this->request->data['DiagnosisMaster']['uhn_site'] = 'female genital-endometrium';	
		$this->DiagnosisMaster->addWritableField(array('uhn_site'));	
	} else if($dx_ctrl['DiagnosisControl']['controls_type'] == 'primary diagnosis unknown') {
		$this->request->data['DiagnosisMaster']['uhn_site'] = 'unknown';
		$this->DiagnosisMaster->addWritableField(array('uhn_site'));		
	}
	if(isset($this->request->data['DiagnosisMaster']['uhn_site']) && in_array($this->request->data['DiagnosisMaster']['uhn_site'], array('female genital-endometrium', 'female genital-ovary'))
	&& $dx_ctrl['DiagnosisControl']['category'] == 'primary' && !in_array($dx_ctrl['DiagnosisControl']['controls_type'], array('ovary','endometrium'))) {
		$submitted_data_validates = false;
		$this->DiagnosisMaster->validationErrors['uhn_site'][] = 'use either ovarian or endometrium diagnosis for this type of tumor';
	}