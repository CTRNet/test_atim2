<?php
if (in_array($tx['TreatmentControl']['tx_method'], array(
    'chemotherapy',
    'hormonotherapy',
    'immunotherapy'
))) {
    $chemoDetail = array();
    if ($tx['TreatmentMaster']['protocol_master_id'])
        $chemoDetail[0] = $protocolFromId[$tx['TreatmentMaster']['protocol_master_id']];
    foreach ($treatmentExtendModel->find('all', array(
        'conditions' => array(
            'TreatmentExtendMaster.treatment_master_id' => $tx['TreatmentMaster']['id']
        )
    )) as $drug)
        $chemoDetail[1][$drug['TreatmentExtendDetail']['drug_id']] = $drugFromId[$drug['TreatmentExtendDetail']['drug_id']];
    if (isset($chemoDetail[1]))
        $chemoDetail[1] = implode(' + ', $chemoDetail[1]);
    $chemoDetail = implode(' : ', $chemoDetail);
    $chronolgyDataTreatmentStart['chronology_details'] = $chemoDetail;
    if (! empty($tx['TreatmentMaster']['finish_date'])) {
        $chronolgyDataTreatmentFinish['chronology_details'] = $chronolgyDataTreatmentStart['chronology_details'];
    }
}