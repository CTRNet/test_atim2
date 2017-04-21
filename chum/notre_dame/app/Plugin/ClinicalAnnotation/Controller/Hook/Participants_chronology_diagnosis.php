<?php 

	if($dx['DiagnosisControl']['category'].'-'.$dx['DiagnosisControl']['controls_type'] == 'primary-sardo') {
		if(preg_match('/^([cC][0-9]{2})\./', $dx['DiagnosisMaster']['topography'], $matches)) {
			$chronolgy_data_diagnosis['chronology_details'] = $icd_o_3_topo_categories[strtoupper($matches[1])];
		}
	} else if($dx['DiagnosisControl']['category'].'-'.$dx['DiagnosisControl']['controls_type'] == 'progression - locoregional-sardo') {
		$chronolgy_data_diagnosis['chronology_details'] = $sardo_progression_details[$dx['DiagnosisDetail']['detail']];
	}
