<?php
switch ($annotation['EventControl']['event_type']) {
    case 'progestin receptor report (RP)':
    case 'estrogen receptor report (RE)':
        $chronolgy_data_annotation['chronology_details'] = $estrogen_progestin_receptor_results[$annotation['EventDetail']['result']];
        break;
    case 'her2/neu':
        $chronolgy_data_annotation['chronology_details'] = $her2_neu_results[$annotation['EventDetail']['result']];
        break;
    case 'genetic test':
        $chronolgy_data_annotation['event'] .= ' - ' . $genetic_tests[$annotation['EventDetail']['test']];
        $chronolgy_data_annotation['chronology_details'] = $annotation['EventDetail']['result'];
        break;
    case 'psa':
    case 'ca125':
        $chronolgy_data_annotation['chronology_details'] = $annotation['EventDetail']['value'];
        break;
    case 'scc':
        $chronolgy_data_annotation['chronology_details'] = $annotation['EventDetail']['value'] . ' ug/l';
        break;
    case 'other marker':
        if (strlen($annotation['EventDetail']['value'])) {
            if (strlen($lab_marker_types[$annotation['EventDetail']['type']]))
                $chronolgy_data_annotation['event'] = $lab_marker_types[$annotation['EventDetail']['type']];
            $chronolgy_data_annotation['chronology_details'] = $annotation['EventDetail']['value'] . ' ' . $lab_marker_units[$annotation['EventDetail']['unit']];
        }
        break;
    default:
}
