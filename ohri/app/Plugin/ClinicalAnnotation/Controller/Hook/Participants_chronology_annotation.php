<?php
$ohriDetails = array();
$fieldToCheck = 'response';
$domainToCheck = 'response';
if (isset($annotation['EventDetail'][$fieldToCheck])) {
    $ohriDetails[] = isset($domainNamesToValues[$domainToCheck]['data'][$annotation['EventDetail'][$fieldToCheck]]) ? $domainNamesToValues[$domainToCheck]['data'][$annotation['EventDetail'][$fieldToCheck]] : $annotation['EventDetail'][$fieldToCheck];
}
$fieldToCheck = 'disease_status';
$domainToCheck = 'ohri_disease_status';
if (isset($annotation['EventDetail'][$fieldToCheck])) {
    $ohriDetails[] = isset($domainNamesToValues[$domainToCheck]['data'][$annotation['EventDetail'][$fieldToCheck]]) ? $domainNamesToValues[$domainToCheck]['data'][$annotation['EventDetail'][$fieldToCheck]] : $annotation['EventDetail'][$fieldToCheck];
}
if(isset($annotation['EventDetail']['CA125_u_ml'])) {
    $ohriDetails[] = __('CA125 u/ml') . ' : ' . $annotation['EventDetail']['CA125_u_ml']; 
}
if(isset($annotation['EventDetail']['ca125_progression'])) {
    $ohriDetails[] = __('progression') . ' : ' . str_replace(array('y', 'n'), array(__('yes'), __('no')), $annotation['EventDetail']['ca125_progression']);
}
$chronolgyDataAnnotation['chronology_details'] = implode(' - ', $ohriDetails);