<?php
switch ($annotation['EventControl']['event_type']) {
    case 'progestin receptor report (RP)':
    case 'estrogen receptor report (RE)':
        $chronolgyDataAnnotation['chronology_details'] = $estrogenProgestinReceptorResults[$annotation['EventDetail']['result']];
        break;
    case 'her2/neu':
        $chronolgyDataAnnotation['chronology_details'] = $her2NeuResults[$annotation['EventDetail']['result']];
        break;
    case 'genetic test':
        $chronolgyDataAnnotation['event'] .= ' - ' . $geneticTests[$annotation['EventDetail']['test']];
        $chronolgyDataAnnotation['chronology_details'] = $annotation['EventDetail']['result'];
        break;
    case 'psa':
    case 'ca125':
        $chronolgyDataAnnotation['chronology_details'] = $annotation['EventDetail']['value'];
        break;
    case 'scc':
        $chronolgyDataAnnotation['chronology_details'] = $annotation['EventDetail']['value'] . ' ug/l';
        break;
    case 'other marker':
        if (strlen($annotation['EventDetail']['value'])) {
            if (strlen($labMarkerTypes[$annotation['EventDetail']['type']]))
                $chronolgyDataAnnotation['event'] = $labMarkerTypes[$annotation['EventDetail']['type']];
            $chronolgyDataAnnotation['chronology_details'] = $annotation['EventDetail']['value'] . ' ' . $labMarkerUnits[$annotation['EventDetail']['unit']];
        }
        break;
    default:
}