<?php 
	
	foreach($this->request->data as &$new_diagnosis) {
		if($new_diagnosis['DiagnosisMaster']['icd10_code']) {
			$icd_10_data = $this->CodingIcd10Who->find('first', array('conditions' => array('CodingIcd10Who.id' => $new_diagnosis['DiagnosisMaster']['icd10_code'])));
			if($icd_10_data) {
				$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
				$new_diagnosis['DiagnosisMaster']['icd10_code'] .= ' '.$icd_10_data['CodingIcd10Who'][$lang.'_description'];
			}
		}
	}