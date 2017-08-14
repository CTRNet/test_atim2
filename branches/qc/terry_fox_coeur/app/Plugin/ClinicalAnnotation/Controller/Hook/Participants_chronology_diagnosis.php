<?php 
	
	switch($dx['DiagnosisControl']['controls_type']) {
		case 'EOC':
			$chronolgy_data_diagnosis['event'] = __('EOC').' '.__('primary').' '.__('diagnosis');
			$chronolgy_data_diagnosis['chronology_details'] = '';
			break;
		case 'other primary cancer':
			$chronolgy_data_diagnosis['event'] = __('other primary cancer');
			$chronolgy_data_diagnosis['chronology_details'] = $qc_tf_tumor_site_values[$dx['DiagnosisMaster']['qc_tf_tumor_site']];
			break;
		case 'recurrence or metastasis':
			$chronolgy_data_diagnosis['event'] = __('recurrence or metastasis');
			$details = array();
			if($dx['DiagnosisMaster']['qc_tf_tumor_site'] && $dx['DiagnosisMaster']['qc_tf_tumor_site'] != 'unknown') {
				$details[] = $qc_tf_tumor_site_values[$dx['DiagnosisMaster']['qc_tf_tumor_site']];
			}
			if($dx['DiagnosisMaster']['qc_tf_progression_detection_method'] && !in_array($dx['DiagnosisMaster']['qc_tf_progression_detection_method'], array('unknown', 'not applicable'))) {
				$details[] = __('method').' : '.$qc_tf_progression_detection_method_values[$dx['DiagnosisMaster']['qc_tf_progression_detection_method']];
			}
			$chronolgy_data_diagnosis['chronology_details'] = implode (' || ', $details);
			break;
		default:
	}

