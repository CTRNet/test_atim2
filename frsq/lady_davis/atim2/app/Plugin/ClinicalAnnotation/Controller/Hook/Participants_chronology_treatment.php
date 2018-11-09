<?php
if (in_array($tx['TreatmentControl']['tx_method'], array(
    'chemotherapy',
    'hormonotherapy',
    'immunotherapy',
    'antibody-based',
    'small molecule-based inhibitor'
))) {
    $txDetail = array();
    if ($tx['TreatmentMaster']['protocol_master_id']) {
        $txDetail[0] = $protocolFromId[$tx['TreatmentMaster']['protocol_master_id']];
    }
    if (strlen($chronolgyDataTreatmentStart['chronology_details'])) {
        $txDetail[1] = $chronolgyDataTreatmentStart['chronology_details'];
    }
    $txDetail = implode(' : ', $txDetail);
    $chronolgyDataTreatmentStart['chronology_details'] = $txDetail;
    if (! empty($tx['TreatmentMaster']['finish_date']) && $chronolgyDataTreatmentFinish) {
        $chronolgyDataTreatmentFinish['chronology_details'] = $chronolgyDataTreatmentStart['chronology_details'];
    }
} elseif (in_array($tx['TreatmentControl']['tx_method'], array(
    'surgery',
    'biopsy',
    'radiation'
))) {
    $extendData = array();
    $treatmentExtendConditions = array(
        'TreatmentExtendMaster.treatment_master_id' => $tx['TreatmentMaster']['id']
    );
    foreach ($this->TreatmentExtendMaster->find('all', array(
        'conditions' => $treatmentExtendConditions
    )) as $newTreatmentExtend) {
        $keyField = str_replace(array(
            'surgery',
            'biopsy',
            'radiation'
        ), array(
            'surgical_procedure',
            'biopsy_procedure',
            'radiation_procedure'
        ), $tx['TreatmentControl']['tx_method']);
        if (isset($newTreatmentExtend['TreatmentExtendDetail'][$keyField]) && strlen($newTreatmentExtend['TreatmentExtendDetail'][$keyField])) {
            $extendData[] = $qcLadyTxeProcedures[$tx['TreatmentControl']['tx_method']][$newTreatmentExtend['TreatmentExtendDetail'][$keyField]];
        }
    }
    $extendData = implode(' & ', $extendData);
    $chronolgyDataTreatmentStart['chronology_details'] = $extendData;
    if (! empty($tx['TreatmentMaster']['finish_date']) && $chronolgyDataTreatmentFinish) {
        $chronolgyDataTreatmentFinish['chronology_details'] = $extendData;
    }
}