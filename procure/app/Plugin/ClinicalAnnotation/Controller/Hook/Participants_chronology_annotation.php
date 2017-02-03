<?php 
	
	switch($annotation['EventControl']['event_type']) {
		case 'questionnaire':
			$chronolgy_data_annotation['date'] = $annotation['EventDetail']['recovery_date'];
			$chronolgy_data_annotation['date_accuracy'] = $annotation['EventDetail']['recovery_date_accuracy'];
			$chronolgy_data_annotation['event'] = __($annotation['EventControl']['event_type']);
			break;
		case 'prostate cancer - diagnosis':
			$chronolgy_data_annotation['date'] = $annotation['EventDetail']['biopsy_pre_surgery_date'];
			$chronolgy_data_annotation['date_accuracy'] = $annotation['EventDetail']['biopsy_pre_surgery_date_accuracy'];
			$chronolgy_data_annotation['event'] = __($annotation['EventControl']['event_type']);
			break;
		case 'laboratory':
			$lab_data = array();
			if(strlen($annotation['EventDetail']['psa_total_ngml'])) {
				$tmp_annotation = $chronolgy_data_annotation;
				$chronology_events = array();
				$chronology_details = array();
				if(strlen($annotation['EventDetail']['psa_total_ngml'])) {
					$chronology_events[] = __('total ng/ml');
					$chronology_details[] = $annotation['EventDetail']['psa_total_ngml'];
				}
				$tmp_annotation['event'] = __('psa').' '.implode(' / ', $chronology_events);
				$tmp_annotation['chronology_details'] = implode(' / ', $chronology_details);
				$lab_data[] = $tmp_annotation;
			}
			if($annotation['EventDetail']['biochemical_relapse'] == 'y')  {
				$tmp_annotation = $chronolgy_data_annotation;
				$tmp_annotation['event'] = __('biochemical relapse');
				$tmp_annotation['chronology_details'] = '';
				$lab_data[] = $tmp_annotation;
			}
			if(strlen($annotation['EventDetail']['testosterone_nmoll'])) {
				$tmp_annotation = $chronolgy_data_annotation;
				$tmp_annotation['event'] = __('testosterone - nmol/l');
				$tmp_annotation['chronology_details'] = $annotation['EventDetail']['testosterone_nmoll'];
				$lab_data[] = $tmp_annotation;
			}
			while(sizeof($lab_data) > 1) {
				$add_to_tmp_array(array_shift($lab_data));
			}
			$chronolgy_data_annotation = array_shift($lab_data);
			break;
		case 'clinical exam':
			$exam_data = array();
			// Add Exam
			$exam_type = $procure_exam_types_values[$annotation['EventDetail']['type']];
			$exam_precision = $clinical_exam_site_values[$annotation['EventDetail']['site_precision']];
			$exam_result = $procure_exam_results_values[$annotation['EventDetail']['results']];
			$chronolgy_data_annotation['event'] = $exam_type.' '.$exam_precision;
			$chronolgy_data_annotation['chronology_details'] = $exam_result;
			$exam_data[] = $chronolgy_data_annotation;
			// Add progression
			if(strlen($annotation['EventDetail']['progression_comorbidity'])) {
				$chronolgy_data_annotation['event'] = __('progression / comorbidity');
				$chronolgy_data_annotation['chronology_details'] = $procure_progressions_comorbidities_values[$annotation['EventDetail']['progression_comorbidity']];
				$exam_data[] = $chronolgy_data_annotation;
			}
			while(sizeof($exam_data) > 1) {
				$add_to_tmp_array(array_shift($exam_data));
			}
			$chronolgy_data_annotation = array_shift($exam_data);
			break;		
		case 'other tumor diagnosis':
			$chronolgy_data_annotation['event'] = __('other tumor - diagnosis');
			$chronolgy_data_annotation['chronology_details'] = $procure_other_tumor_sites_values[$annotation['EventDetail']['tumor_site']];
			break;
		case 'clinical note':
			$chronolgy_data_annotation['event'] = __('clinical notes');
			$chronolgy_data_annotation['chronology_details'] = $procure_event_note_type_values[$annotation['EventDetail']['type']];
			break;	
		case 'procure pathology report':
			$chronolgy_data_annotation['event'] = __($annotation['EventControl']['event_type']);
		case 'visit/contact':	
			$chronolgy_data_annotation['event'] = __($annotation['EventControl']['event_type']);
			break;
	}
