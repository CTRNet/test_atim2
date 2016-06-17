<?php 
	
	switch($dx['DiagnosisControl']['category']) {
		case 'secondary':
			if($dx['DiagnosisMaster']['icd10_code'] && isset($chus_secondary_icd10_codes[$dx['DiagnosisMaster']['icd10_code']])) {
				$chronolgy_data_diagnosis['chronology_details'] = $chus_secondary_icd10_codes[$dx['DiagnosisMaster']['icd10_code']];
			}
			break;
		default:
	}
