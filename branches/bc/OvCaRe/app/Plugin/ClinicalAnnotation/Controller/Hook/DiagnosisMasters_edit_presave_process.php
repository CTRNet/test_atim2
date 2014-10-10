<?php
	if(isset($this->request->data['DiagnosisMaster']['ovcare_tumor_site']) && $dx_master_data['DiagnosisControl']['category'] != 'secondary') {
		if($dx_master_data['DiagnosisControl']['controls_type'] == 'ovary or endometrium tumor') {
			if(!in_array($this->request->data['DiagnosisMaster']['ovcare_tumor_site'], array('female genital-ovary','female genital-endometrium'))) {
				$submitted_data_validates = false;
				$this->DiagnosisMaster->validationErrors[][] = __('wrong selected tumor site').' : '.__('either ovary or endometrium tumor tumor site should be selected');
			}
		} else {
			if(in_array($this->request->data['DiagnosisMaster']['ovcare_tumor_site'], array('female genital-ovary','female genital-endometrium'))) {
				$submitted_data_validates = false;
				$this->DiagnosisMaster->validationErrors[][] = __('wrong selected tumor site').' : '.__('selected tumor site should be different than ovary or endometrium tumor');
			}
		}
	}
	
?>