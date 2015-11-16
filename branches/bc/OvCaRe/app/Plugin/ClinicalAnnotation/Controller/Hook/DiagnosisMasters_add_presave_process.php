<?php

	if($dx_ctrl['DiagnosisControl']['controls_type'] == 'primary diagnosis unknown') {
		$this->DiagnosisMaster->addWritableField(array('ovcare_tumor_site'));
		$this->request->data['DiagnosisMaster']['ovcare_tumor_site'] = 'unknown';	
	} else if(isset($this->request->data['DiagnosisMaster']['ovcare_tumor_site']) && $dx_ctrl['DiagnosisControl']['category'] != 'secondary') {
		if($dx_ctrl['DiagnosisControl']['controls_type'] == 'ovary or endometrium tumor') {
			if(!in_array($this->request->data['DiagnosisMaster']['ovcare_tumor_site'], array('female genital-ovary','female genital-endometrium','female genital-ovary and endometrium'))) {
				$submitted_data_validates = false;
				$this->DiagnosisMaster->validationErrors[][] = __('wrong selected tumor site').' : '.__('either ovary or endometrium tumor site should be selected');
			}			
		} else {
			if(in_array($this->request->data['DiagnosisMaster']['ovcare_tumor_site'], array('female genital-ovary','female genital-endometrium','female genital-ovary and endometrium'))) {
				$submitted_data_validates = false;
				$this->DiagnosisMaster->validationErrors[][] = __('wrong selected tumor site').' : '.__('selected tumor site should be different than ovary or endometrium tumor');
			}
		}
	}
	
?>