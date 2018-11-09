<?php
if (isset($annotation['EventDetail']['response'])) {
    $chronolgyDataAnnotation['chronology_details'] = isset($imageResponseValues[$annotation['EventDetail']['response']]) ? $imageResponseValues[$annotation['EventDetail']['response']] : $annotation['EventDetail']['response'];
} elseif ($annotation['EventControl']['event_type'] == 'blood marker') {
    if (strlen($annotation['EventDetail']['type']) && strlen($annotation['EventDetail']['value'])) {
        $chronolgyDataAnnotation['chronology_details'] = $qcLadyMarkersDropDownList['blood_marker'][$annotation['EventDetail']['type']] . ' : ' . $annotation['EventDetail']['value'] . ' ' . $qcLadyMarkersDropDownList['blood_marker_unit'][$annotation['EventDetail']['test_unit']];
    }
} elseif ($annotation['EventControl']['event_type'] == 'genetic marker') {
    if (strlen($annotation['EventDetail']['marker']) && strlen($annotation['EventDetail']['result'])) {
        $chronolgyDataAnnotation['chronology_details'] = $qcLadyMarkersDropDownList['genetic_markers'][$annotation['EventDetail']['marker']] . ' : ' . $qcLadyMarkersDropDownList['genetic_markers_results'][$annotation['EventDetail']['result']];
    }
}
