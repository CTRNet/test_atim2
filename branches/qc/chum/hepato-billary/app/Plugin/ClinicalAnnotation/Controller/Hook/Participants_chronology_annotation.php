<?php
$chronolgyDataAnnotation['event'] = __($annotation['EventControl']['event_type']);
if (isset($annotation['EventDetail']['disease_status']) && $annotation['EventDetail']['disease_status']) {
    $chronolgyDataAnnotation['chronology_details'] = __($annotation['EventDetail']['disease_status']);
}
if (isset($annotation['EventDetail']['recurrence_status']) && $annotation['EventDetail']['recurrence_status']) {
    $chronolgyDataAnnotationNew = $chronolgyDataAnnotation;
    $chronolgyDataAnnotationNew['event'] = __('recurrence') . ' - ' . __($annotation['EventDetail']['recurrence_status']);
    $chronolgyDataAnnotationNew['chronology_details'] = '';
    if (isset($annotation['EventDetail']['qc_hb_recurrence_localization']) && $annotation['EventDetail']['qc_hb_recurrence_localization']) {
        $chronolgyDataAnnotationNew['chronology_details'] = $recurrenceLocalizations[$annotation['EventDetail']['qc_hb_recurrence_localization']];
    }
    $addToTmpArray($chronolgyDataAnnotationNew);
}
