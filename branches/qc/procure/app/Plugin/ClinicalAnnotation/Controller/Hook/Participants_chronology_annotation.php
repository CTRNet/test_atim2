<?php 
	
	switch($annotation['EventControl']['event_type']) {
		case 'procure follow-up worksheet - aps':
			$chronolgy_data_annotation['event'] = __('aps');
			$chronolgy_data_annotation['chronology_details'] = $annotation['EventDetail']['total_ngml'] .( $annotation['EventDetail']['biochemical_relapse']? ' (BCR)' : '');
			break;
		case 'procure follow-up worksheet - clinical event':
			$exam_type = $annotation['EventDetail']['type']? $procure_followup_exam_types_values[$annotation['EventDetail']['type']] : '';
			$exam_result = $annotation['EventDetail']['results']? $procure_followup_exam_results_values[$annotation['EventDetail']['results']] : '';
			$chronolgy_data_annotation['event'] = $exam_type;
			$chronolgy_data_annotation['chronology_details'] = strlen($exam_result)? "$exam_result" : '';
			break;
		case 'procure diagnostic information worksheet':
			if($annotation['EventDetail']['biopsy_pre_surgery_date']) {
				$biopsy_data_annotation = array(
					'date'			=> $annotation['EventDetail']['biopsy_pre_surgery_date'],
					'date_accuracy' => isset($annotation['EventDetail']['biopsy_pre_surgery_date_accuracy']) ? $annotation['EventDetail']['biopsy_pre_surgery_date_accuracy'] : 'c',
					'event'			=> __('biopsy'),
					'chronology_details' => '',
					'link'			=> '/ClinicalAnnotation/EventMasters/detail/'.$participant_id.'/'.$annotation['EventMaster']['id']
				);
				$add_to_tmp_array($biopsy_data_annotation);
			}
			$chronolgy_data_annotation['event'] = __($annotation['EventControl']['event_type']);
			$chronolgy_data_annotation['chronology_details'] = $annotation['EventMaster']['procure_form_identification'];
			break;			
		case 'procure questionnaire administration worksheet':
			$chronolgy_data_annotation['date'] = $annotation['EventDetail']['recovery_date'];
			$chronolgy_data_annotation['date_accuracy'] = $annotation['EventDetail']['recovery_date_accuracy'];
			$chronolgy_data_annotation['event'] = __($annotation['EventControl']['event_type']);
			$chronolgy_data_annotation['chronology_details'] = $annotation['EventMaster']['procure_form_identification'];
			break;
		case 'procure follow-up worksheet - other tumor dx':
			$chronolgy_data_annotation['event'] = __('other tumor - diagnosis');
			$chronolgy_data_annotation['chronology_details'] = $annotation['EventDetail']['tumor_site']? $procure_other_tumor_sites_values[$annotation['EventDetail']['tumor_site']] : '';
			break;	
		case 'procure follow-up worksheet - clinical note':
			$chronolgy_data_annotation['event'] = __('clinical notes');
			$chronolgy_data_annotation['chronology_details'] = '';
			break;	
		default:
			$chronolgy_data_annotation['event'] = __($annotation['EventControl']['event_type']);
			$chronolgy_data_annotation['chronology_details'] = $annotation['EventMaster']['procure_form_identification'];
			if($annotation['EventControl']['event_type'] == 'procure follow-up worksheet' && $annotation['EventDetail']['surgery_date']){
				$biopsy_data_annotation = array(
					'date'			=> $annotation['EventDetail']['surgery_date'],
					'date_accuracy' => isset($annotation['EventDetail']['surgery_date_accuracy']) ? $annotation['EventDetail']['surgery_date_accuracy'] : 'c',
					'event'			=> __('surgery for metastases'),
					'chronology_details' => '',
					'link'			=> '/ClinicalAnnotation/EventMasters/detail/'.$participant_id.'/'.$annotation['EventMaster']['id']
				);
				$add_to_tmp_array($biopsy_data_annotation);				
			}
	}
