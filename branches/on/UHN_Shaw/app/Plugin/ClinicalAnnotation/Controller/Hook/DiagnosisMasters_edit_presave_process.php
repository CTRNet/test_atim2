<?php
	
	if(isset($this->request->data['DiagnosisMaster']['uhn_site']) && in_array($this->request->data['DiagnosisMaster']['uhn_site'], array('female genital-endometrium', 'female genital-ovary'))
	&& $dx_master_data['DiagnosisControl']['category'] == 'primary' && !in_array($dx_master_data['DiagnosisControl']['controls_type'], array('ovary','endometrium'))) {
		$submitted_data_validates = false;
		$this->DiagnosisMaster->validationErrors['uhn_site'][] = 'use either ovarian or endometrium diagnosis for this type of tumor';
	}