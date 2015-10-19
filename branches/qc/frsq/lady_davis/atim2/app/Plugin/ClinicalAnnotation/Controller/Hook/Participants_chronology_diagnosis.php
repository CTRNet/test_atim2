<?php
	
	if(isset($dx['DiagnosisDetail']['qc_lady_tumor_site'])) {
		$chronolgy_data_diagnosis['chronology_details'] = isset($qc_lady_tumor_site[$dx['DiagnosisDetail']['qc_lady_tumor_site']])? $qc_lady_tumor_site[$dx['DiagnosisDetail']['qc_lady_tumor_site']] : $dx['DiagnosisDetail']['qc_lady_tumor_site'];
	}