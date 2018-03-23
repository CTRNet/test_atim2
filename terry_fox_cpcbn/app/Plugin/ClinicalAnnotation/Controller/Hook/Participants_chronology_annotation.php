<?php
$chronolgyDataAnnotation['event'] = __($annotation['EventControl']['event_type']);
switch ($annotation['EventControl']['event_type']) {
    case 'psa':
        $chronolgyDataAnnotation['chronology_details'] = $annotation['EventDetail']['psa_ng_per_ml'];
        break;
}