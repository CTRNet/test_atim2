<?php 
	
	switch($annotation['EventControl']['event_type']) {
		case 'medical history':
			$chronolgy_data_annotation['chronology_details'] = $annotation['EventDetail']['body_system'];
			break;
		default:
	}
