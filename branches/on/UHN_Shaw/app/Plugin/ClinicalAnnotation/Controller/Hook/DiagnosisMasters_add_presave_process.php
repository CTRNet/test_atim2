<?php
	
	if($dx_ctrl['DiagnosisControl']['controls_type'] == 'primary diagnosis unknown') {
		$this->request->data['DiagnosisMaster']['uhn_site'] = 'unknown';
		$this->DiagnosisMaster->addWritableField(array('uhn_site'));		
	} else if($dx_ctrl['DiagnosisControl']['controls_type'] == 'ovary') {
		$this->request->data['DiagnosisMaster']['uhn_site'] = 'female genital-ovary';
		$this->DiagnosisMaster->addWritableField(array('uhn_site'));		
	} else if(isset($this->request->data['DiagnosisMaster']['uhn_site']) && $this->request->data['DiagnosisMaster']['uhn_site'] == 'female genital-ovary') {
		$submitted_data_validates = false;
		$this->DiagnosisMaster->validationErrors['uhn_site'][] = 'use ovarian diagnosis for any either ovarian tumor or ovarian metastasis ';
	}
	