<?php
$event = __('diagnosis') . ' - ' . __($dx['DiagnosisControl']['controls_type']);
switch ($dx['DiagnosisControl']['controls_type']) {
    case 'breast progression':
        $chronologyDetails = $beastDxProgressionSite[$dx['DiagnosisDetail']['site']];
        break;
    case 'other cancer':
        $chronologyDetails = $ctrnetSubmissionDiseaseSiteValues[$dx['DiagnosisDetail']['disease_site']];
        break;
    case 'other cancer progression':
        $chronologyDetails = $otherDxProgressionSites[$dx['DiagnosisDetail']['secondary_disease_site']];
        break;
    default:
        $chronologyDetails = '';
}
$chronolgyDataDiagnosis['event'] = $event;
$chronolgyDataDiagnosis['chronology_details'] = $chronologyDetails;