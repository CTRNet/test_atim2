<?php
	if(isset($this->request->data['DiagnosisMaster']['ovcare_tumor_site'])) {
		$tmp_ovcare_tumor_site = $this->request->data['DiagnosisMaster']['ovcare_tumor_site'];
		switch($dx_master_data['DiagnosisControl']['controls_type']){
			case 'ovary':
				$this->request->data['DiagnosisMaster']['ovcare_tumor_site'] = 'female genital-ovary';
				break;
			case 'primary diagnosis unknown':
				$this->request->data['DiagnosisMaster']['ovcare_tumor_site'] = 'unknown';
				break;
		}
		if($tmp_ovcare_tumor_site != $this->request->data['DiagnosisMaster']['ovcare_tumor_site']) {
			AppController::addWarningMsg(__('updated automatically tumor site to appropriated value'));
		}
	}
	
?>