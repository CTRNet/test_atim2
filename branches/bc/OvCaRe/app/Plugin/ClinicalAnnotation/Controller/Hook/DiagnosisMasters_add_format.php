<?php

	if (empty($this->request->data) ) {
		switch($dx_ctrl['DiagnosisControl']['controls_type']){
			case 'ovary or endometrium':
				$this->set('default_tumor_site', 'female genital-ovary');
				break;
		}
	}

?>