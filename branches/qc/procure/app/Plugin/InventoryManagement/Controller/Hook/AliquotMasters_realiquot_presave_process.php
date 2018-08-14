<?php
$recordCounter = 0;
foreach ($this->request->data as $procureAliquotDataSet) {
    $recordCounter ++;
    $procureParticipantIdentifier = $procureVisit = null;
    if (preg_match('/^(PS[1-4]P[0-9]{4})\ ([Vv]((0[1-9])|([1-9][0-9]))([\.,]([1-9])){0,1})/', $procureAliquotDataSet['parent']['AliquotMaster']['barcode'], $matches)) {
        $procureParticipantIdentifier = $matches[1];
        $procureVisit = $matches[2];
    }
    foreach ($procureAliquotDataSet['children'] as $procureAliquotData) {
        $barcodeError = $this->AliquotMaster->validateBarcode($procureAliquotData['AliquotMaster']['barcode'], Configure::read('procure_bank_id'), $procureParticipantIdentifier, $procureVisit);
        if ($barcodeError)
            $errors['barcode'][$barcodeError][$recordCounter] = $recordCounter;
    }
}

if (empty($errors)) {
    $tmpSampleControl = $this->SampleControl->getOrRedirect($childAliquotCtrl['AliquotControl']['sample_control_id']);
    foreach ($this->request->data as &$createdAliquots) {
        foreach ($createdAliquots['children'] as &$newAliquot) {
            if ($tmpSampleControl['SampleControl']['sample_type'] == 'rna')
                list ($newAliquot['AliquotDetail']['procure_total_quantity_ug'], $newAliquot['AliquotDetail']['procure_total_quantity_ug_nanodrop']) = $this->AliquotMaster->calculateRnaQuantity($newAliquot);
            $newAliquot['AliquotMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
        }
    }
    $childWritableFields['aliquot_masters']['addgrid'] = array_merge($childWritableFields['aliquot_masters']['addgrid'], array(
        'procure_created_by_bank'
    ));
    if (! isset($childWritableFields[$childAliquotCtrl['AliquotControl']['detail_tablename']]['addgrid']))
        $childWritableFields[$childAliquotCtrl['AliquotControl']['detail_tablename']]['addgrid'] = array();
    $childWritableFields[$childAliquotCtrl['AliquotControl']['detail_tablename']]['addgrid'] = array_merge($childWritableFields[$childAliquotCtrl['AliquotControl']['detail_tablename']]['addgrid'], array(
        'procure_total_quantity_ug',
        'procure_total_quantity_ug_nanodrop'
    ));
}