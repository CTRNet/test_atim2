<?php
$chronolgyDataTreatmentStart['event'] = __($tx['TreatmentControl']['tx_method']) . $startSuffixMsg;
if ($chronolgyDataTreatmentFinish) {
    $chronolgyDataTreatmentFinish['event'] = __($tx['TreatmentControl']['tx_method']) . $finishSuffixMsg;
}        
if (isset($tx['TreatmentDetail']['qc_hb_treatment']) && $tx['TreatmentDetail']['qc_hb_treatment']) {
    $chemoRegimensDetail = $chemoRegimens[$tx['TreatmentDetail']['qc_hb_treatment']];
    $chronolgyDataTreatmentStart['chronology_details'] = $chemoRegimensDetail . ' : ' . $chronolgyDataTreatmentStart['chronology_details'];
    if ($chronolgyDataTreatmentFinish) {
        $chronolgyDataTreatmentFinish['chronology_details'] = $chemoRegimensDetail . ' : ' . $chronolgyDataTreatmentFinish['chronology_details'];
    }
}
if (isset($tx['TreatmentDetail']['principal_surgery']) && $tx['TreatmentDetail']['principal_surgery']) {
    $principalSurgeryDetail = $principalSurgeries[$tx['TreatmentDetail']['principal_surgery']];
    $chronolgyDataTreatmentStart['chronology_details'] = $principalSurgeryDetail;
    if ($chronolgyDataTreatmentFinish) {
        $chronolgyDataTreatmentFinish['chronology_details'] = $principalSurgeryDetail;
    }
}
