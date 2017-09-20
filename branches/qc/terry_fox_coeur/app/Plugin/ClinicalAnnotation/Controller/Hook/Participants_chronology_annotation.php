<?php
$chronolgyDataAnnotation['event'] = __($annotation['EventControl']['event_type']);
switch ($annotation['EventControl']['event_type']) {
    case 'ct scan':
        $chronolgyDataAnnotation['chronology_details'] = __($annotation['EventDetail']['scan_precision']);
        break;
    case 'ca125':
        $chronolgyDataAnnotation['chronology_details'] = __($annotation['EventDetail']['precision_u']) . ' (u)';
        break;
    case 'biopsy':
        if ($annotation['EventControl']['disease_site'] == 'EOC') {
            $chronolgyDataAnnotation['event'] .= ' [' . __('EOC') . ']';
        }
        break;
}