<?php
if (in_array($tx['TreatmentControl']['tx_method'], array(
    'chemotherapy',
    'hormonotherapy',
    'immunotherapy'
))) {
    $chemoDetail = array();
    if ($tx['TreatmentMaster']['protocol_master_id']) {
        $chemoDetail[0] = $protocolFromId[$tx['TreatmentMaster']['protocol_master_id']];
    }
    if (strlen($chronolgyDataTreatmentStart['chronology_details'])) {
        $chemoDetail[1] = $chronolgyDataTreatmentStart['chronology_details'];
    }
    $chemoDetail = implode(' : ', $chemoDetail);
    $chronolgyDataTreatmentStart['chronology_details'] = $chemoDetail;
    if (! empty($tx['TreatmentMaster']['finish_date'])) {
        $chronolgyDataTreatmentFinish['chronology_details'] = $chronolgyDataTreatmentStart['chronology_details'];
    }
}