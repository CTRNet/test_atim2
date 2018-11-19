<?php
if ($tx['TreatmentControl']['tx_method'] != 'chemotherapy') {
    $ohriDetails = array();
    $fieldToCheck = 'description';
    $domainToCheck = 'Surgery: Description';
    if (isset($tx['TreatmentDetail'][$fieldToCheck])) {
        $ohriDetails[] = isset($domainNamesToValues[$domainToCheck]['data'][$tx['TreatmentDetail'][$fieldToCheck]]) ? $domainNamesToValues[$domainToCheck]['data'][$tx['TreatmentDetail'][$fieldToCheck]] : $tx['TreatmentDetail'][$fieldToCheck];
    }
    $fieldToCheck = 'tx_intent';
    $domainToCheck = 'intent';
    if (isset($tx['TreatmentMaster'][$fieldToCheck])) {
        $ohriDetails[] = isset($domainNamesToValues[$domainToCheck]['data'][$tx['TreatmentMaster'][$fieldToCheck]]) ? $domainNamesToValues[$domainToCheck]['data'][$tx['TreatmentMaster'][$fieldToCheck]] : $tx['TreatmentMaster'][$fieldToCheck];
    }
    $fieldToCheck = 'residual_disease';
    $domainToCheck = 'ohri_residual_disease';
    if (isset($tx['TreatmentDetail'][$fieldToCheck])) {
        $ohriDetail = isset($domainNamesToValues[$domainToCheck]['data'][$tx['TreatmentDetail'][$fieldToCheck]]) ? $domainNamesToValues[$domainToCheck]['data'][$tx['TreatmentDetail'][$fieldToCheck]] : $tx['TreatmentDetail'][$fieldToCheck];
        $ohriDetails[] = __('residual disease') . ' : ' . $ohriDetail;
    }
    $chronolgyDataTreatmentStart['chronology_details'] = implode(' - ', $ohriDetails);
    if (! empty($tx['TreatmentMaster']['finish_date']) && $chronolgyDataTreatmentFinish) {
        $chronolgyDataTreatmentFinish['chronology_details'] = $chronolgyDataTreatmentStart['chronology_details'];
    }
}