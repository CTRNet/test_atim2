<?php

	if (empty($this->request->data) ) {
		switch($dx_ctrl['DiagnosisControl']['controls_type']){
			case 'ovary':
				$this->set('default_tumor_site', 'female genital-ovary');
				break;
			case 'primary diagnosis unknown':
				$this->set('default_tumor_site', 'unknown');
				break;
		}
	}

?>