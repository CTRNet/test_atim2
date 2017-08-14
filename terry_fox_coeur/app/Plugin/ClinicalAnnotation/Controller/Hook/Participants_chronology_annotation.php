<?php 

$chronolgy_data_annotation['event'] = __($annotation['EventControl']['event_type']);
switch($annotation['EventControl']['event_type']) {
	case 'ct scan':
		$chronolgy_data_annotation['chronology_details'] = __($annotation['EventDetail']['scan_precision']);
		break;
	case 'ca125':
		$chronolgy_data_annotation['chronology_details'] = __($annotation['EventDetail']['precision_u']).' (u)';
		break;
	case 'biopsy':
	    if($annotation['EventControl']['disease_site'] == 'EOC') {
	        $chronolgy_data_annotation['event'] .= ' ['.__('EOC').']';
	    }
		break;	
}
	
