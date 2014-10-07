<?php
	if(isset($this->request->data['DiagnosisMaster']['ovcare_tumor_site'])) {
		if($dx_master_data['DiagnosisControl']['controls_type'] == 'ovary or endometrium') {
			if(!in_array($this->request->data['DiagnosisMaster']['ovcare_tumor_site'], array('female genital-ovary','female genital-endometrium'))) {
				$submitted_data_validates = false;
				$this->DiagnosisMaster->validationErrors[][] = __('wrong selected tumor site');
			}
		} else {
			if(in_array($this->request->data['DiagnosisMaster']['ovcare_tumor_site'], array('female genital-ovary','female genital-endometrium'))) {
				$submitted_data_validates = false;
				$this->DiagnosisMaster->validationErrors[][] = __('wrong selected tumor site');
			}
		}
	}
	
?>