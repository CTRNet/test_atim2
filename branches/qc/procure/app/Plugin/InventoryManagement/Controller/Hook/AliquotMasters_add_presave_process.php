<?php

// $aliquotControl
if ($aliquotControl['AliquotControl']['aliquot_type'] == 'whatman paper') {
    AppController::addWarningMsg(__('whatman paper should not be created anymore'));
}

// Validate match between barcode, participant_identifier and visit
$recordCounter = 0;
foreach ($this->request->data as &$procureNewSampleAliquotsSet) {
    $recordCounter ++;
    $procureParticipantIdentifier = $procureNewSampleAliquotsSet['parent']['ViewSample']['participant_identifier'];
    $procureVisit = $procureNewSampleAliquotsSet['parent']['ViewSample']['procure_visit'];
    $lineCounter = 0;
    foreach ($procureNewSampleAliquotsSet['children'] as &$procureNewAliquot) {
        $lineCounter ++;
        $barcodeError = $this->AliquotMaster->validateBarcode($procureNewAliquot['AliquotMaster']['barcode'], Configure::read('procure_bank_id'), $procureParticipantIdentifier, $procureVisit);
        if ($barcodeError)
            $errors['barcode'][$barcodeError][] = ($isBatchProcess ? $recordCounter : $lineCounter);
        $procureNewAliquot['AliquotMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
    }
}
$this->AliquotMaster->addWritableField(array(
    'procure_created_by_bank'
));

if (empty($errors)) {
    $quantityCalculated = false;
    foreach ($this->request->data as &$tmpCreatedAliquots) {
        if ($tmpCreatedAliquots['parent']['ViewSample']['sample_type'] == 'rna') {
            $quantityCalculated = true;
            foreach ($tmpCreatedAliquots['children'] as &$tmpNewAliquot) {
                list ($tmpNewAliquot['AliquotDetail']['procure_total_quantity_ug'], $tmpNewAliquot['AliquotDetail']['procure_total_quantity_ug_nanodrop']) = $this->AliquotMaster->calculateRnaQuantity($tmpNewAliquot);
            }
        }
    }
    if ($quantityCalculated)
        $this->AliquotMaster->addWritableField(array(
            'procure_total_quantity_ug',
            'procure_total_quantity_ug_nanodrop'
        ));
}