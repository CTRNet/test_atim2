<?php 

	$chronolgy_data_diagnosis['event'] =  __('diagnosis').' - '.__($dx['DiagnosisControl']['controls_type']);
	switch($dx['DiagnosisControl']['controls_type']) {
		case 'breast':
			$chronolgy_data_diagnosis['chronology_details'] = isset($beast_dx_intervention[$dx['DiagnosisDetail']['type_of_intervention']])? $beast_dx_intervention[$dx['DiagnosisDetail']['type_of_intervention']] : $dx['DiagnosisDetail']['type_of_intervention'];
			break;
		case 'breast progression':
			$chronolgy_data_diagnosis['chronology_details'] = isset($beast_dx_progression_site[$dx['DiagnosisDetail']['site']])? $beast_dx_progression_site[$dx['DiagnosisDetail']['site']] : $dx['DiagnosisDetail']['site'];
			break;
		case 'other cancer':
			$chronolgy_data_diagnosis['chronology_details'] = isset($ctrnet_submission_disease_site_values[$dx['DiagnosisDetail']['disease_site']])? $ctrnet_submission_disease_site_values[$dx['DiagnosisDetail']['disease_site']] : $dx['DiagnosisDetail']['disease_site'];
			break;
	}
