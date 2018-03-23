<?php
$chronolgyDataTreatmentStart['event'] = __($tx['TreatmentControl']['tx_method']) . $startSuffixMsg;
if ($chronolgyDataTreatmentFinish) {
    $chronolgyDataTreatmentFinish['event'] = __($tx['TreatmentControl']['tx_method']) . $finishSuffixMsg;
}
$tmpChronologyDetails = array(
    isset($tx['TreatmentDetail']['qc_tf_disease_free_survival_start_events']) && $tx['TreatmentDetail']['qc_tf_disease_free_survival_start_events'] ? __('disease free survival start event') : ''
);
switch ($tx['TreatmentControl']['tx_method']) {
    case 'biopsy and turp':
        $tmpChronologyDetails[] = $tx['TreatmentDetail']['type'] ? __($tx['TreatmentDetail']['type']) : '';
        $tmpChronologyDetails[] = $tx['TreatmentDetail']['type_specification'] ? __($tx['TreatmentDetail']['type_specification']) : '';
        $tmpChronologyDetails[] = $tx['TreatmentDetail']['sent_to_chum'] ? __('sent to chum') : '';
        break;
    default:
        $tmpChronologyDetails[] = $chronolgyDataTreatmentStart['chronology_details'];
}
$tmpChronologyDetails = array_filter($tmpChronologyDetails);
$tmpChronologyDetails = implode(' - ', $tmpChronologyDetails);
$chronolgyDataTreatmentStart['chronology_details'] = $tmpChronologyDetails;
if ($chronolgyDataTreatmentFinish) {
    $chronolgyDataTreatmentFinish['chronology_details'] = $tmpChronologyDetails;
}