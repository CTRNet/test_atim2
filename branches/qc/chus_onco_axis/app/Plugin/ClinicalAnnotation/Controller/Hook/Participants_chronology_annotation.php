<?php 
	
	switch($annotation['EventControl']['event_type']) {
		case 'medical history':
			if($annotation['EventDetail']['yes_no'] == 'y') {
				$chronolgy_data_annotation['chronology_details'] = $this->StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Medical History Diagnosis', $annotation['EventDetail']['type']);
			} else {
				$chronolgy_data_annotation = false;
			}
			break;
		default:
	}
