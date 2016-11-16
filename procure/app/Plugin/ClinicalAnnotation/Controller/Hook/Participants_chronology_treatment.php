<?php 
	
	switch($tx['TreatmentControl']['tx_method']) {
		case 'treatment':
			$treatment_type =  $procure_treatment_types_values[$tx['TreatmentDetail']['treatment_type']];
			$treatment_detail_properties = array(
				array('TreatmentDetail', 'treatment_precision', $procure_treatment_precision_values),
				array('TreatmentDetail', 'surgery_type', $procure_surgery_type_values),
				array('TreatmentDetail', 'treatment_site', $procure_treatment_site_values),
				array('Drug', 'generic_name', null));				
			$treatment_details = array();
			foreach($treatment_detail_properties as $new_detail) {
				list($model, $field,  $lists) = $new_detail;
				if($lists) {
					$chronolgy_data_annotation['chronology_details'] = $lists[$tx[$model][$field]];
				} else {
					$treatment_details[] = $tx[$model][$field];
				}
			}
			$treatment_details = array_filter($treatment_details);
			$treatment_details = implode(' - ', $treatment_details);
			$chronolgy_data_treatment_start['event'] = "$treatment_type $start_suffix_msg";
			$chronolgy_data_treatment_start['chronology_details'] = $treatment_details;
			if($chronolgy_data_treatment_finish){	
				$chronolgy_data_treatment_finish['event'] = "$treatment_type $finish_suffix_msg";
				$chronolgy_data_treatment_finish['chronology_details'] = $treatment_details;
			}
			break;
	}
	