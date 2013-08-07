<?php

	if($dx_ctrl['DiagnosisControl']['controls_type'] == 'primary diagnosis unknown') {
		$this->DiagnosisMaster->addWritableField(array('ovcare_tumor_site'));
		$this->request->data['DiagnosisMaster']['ovcare_tumor_site'] = 'unknown';	
	} else if(isset($this->request->data['DiagnosisMaster']['ovcare_tumor_site'])) {
		$tmp_ovcare_tumor_site = $this->request->data['DiagnosisMaster']['ovcare_tumor_site'];
		switch($dx_ctrl['DiagnosisControl']['controls_type']){
			case 'ovary':
				$this->request->data['DiagnosisMaster']['ovcare_tumor_site'] = 'female genital-ovary';
				break;
		}
		if($tmp_ovcare_tumor_site != $this->request->data['DiagnosisMaster']['ovcare_tumor_site']) {
			AppController::addWarningMsg(__('updated automatically tumor site to appropriated value'));
		}
	}
	
?>