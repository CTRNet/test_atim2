<?php 

	$event =  __('diagnosis').' - '.__($dx['DiagnosisControl']['controls_type']);
	switch($dx['DiagnosisControl']['controls_type']) {
		case 'breast':
			$chronology_details = $beast_dx_intervention[$dx['DiagnosisDetail']['type_of_intervention']];
			break;
		case 'breast progression':
			$chronology_details = $beast_dx_progression_site[$dx['DiagnosisDetail']['site']];
			break;
		case 'other cancer':
			$event .= ' : '.$ctrnet_submission_disease_site_values[$dx['DiagnosisDetail']['disease_site']];
			break;
		case 'other cancer progression':
			$event .= ' : '.$ctrnet_submission_disease_site_values[$dx['DiagnosisDetail']['primary_disease_site']];
			$chronology_details = $other_dx_progression_sites[$dx['DiagnosisDetail']['secondary_disease_site']];
			break;
		default:
			$chronology_details = '';
	}
	$chronolgy_data_diagnosis['event'] = $event;
	$chronolgy_data_diagnosis['chronology_details'] = $chronology_details;
	