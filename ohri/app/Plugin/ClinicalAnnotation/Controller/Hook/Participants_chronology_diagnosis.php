<?php
$ohriDetails = array();
$fieldToCheck = 'ohri_tumor_site';
$domainToCheck = 'ohri_tumour_site';
if (isset($dx['DiagnosisMaster'][$fieldToCheck])) {
    $ohriDetails[] = isset($domainNamesToValues[$domainToCheck]['data'][$dx['DiagnosisMaster'][$fieldToCheck]]) ? $domainNamesToValues[$domainToCheck]['data'][$dx['DiagnosisMaster'][$fieldToCheck]] : $dx['DiagnosisMaster'][$fieldToCheck];
}
$chronolgyDataDiagnosis['chronology_details'] = implode(' - ', $ohriDetails);