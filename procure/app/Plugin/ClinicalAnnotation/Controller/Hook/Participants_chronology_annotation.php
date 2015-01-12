<?php 
	
	switch($annotation['EventControl']['event_type']) {
		case 'procure follow-up worksheet - aps':
			$chronolgy_data_annotation['event'] = __('aps');
			$chronolgy_data_annotation['chronology_details'] = $annotation['EventDetail']['total_ngml'] .( $annotation['EventDetail']['biochemical_relapse']? ' (BCR)' : '');
			break;
		case 'procure follow-up worksheet - clinical event':
			$exam_type = $this->StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('procure followup exam types', $annotation['EventDetail']['type']);
			$exam_result = $this->StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Exam Results', $annotation['EventDetail']['results']);
			$chronolgy_data_annotation['event'] = $exam_type;
			$chronolgy_data_annotation['chronology_details'] = strlen($exam_result)? "$exam_result" : '';
			break;
		default:
			$chronolgy_data_annotation['event'] = __($annotation['EventControl']['event_type']);
			$chronolgy_data_annotation['chronology_details'] = $annotation['EventMaster']['procure_form_identification'];
	}

