<?php 

    $chronolgy_data_annotation['event'] = __($annotation['EventControl']['event_type']);
	switch($annotation['EventControl']['event_type']) {
		case 'medical history':
			$chronolgy_data_annotation['chronology_details'] = $this->StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Medical History Body System', $annotation['EventDetail']['body_system']);
			break;
		case 'medication history':
		    $chronolgy_data_annotation['chronology_details'] = $annotation['EventDetail']['medication'];
			break;
		case 'clinical note':
		    $chronolgy_data_annotation['chronology_details'] = $this->StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Clinical Note Types', $annotation['EventDetail']['type']);
		    break;
		default:
	}
