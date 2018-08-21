<?php

// ATiM Processing Site Data Check
// ===================================================
// An aliquot of a sample created by system to migrate aliquot from ATiM-Processing site and defined as created by another bank than the bank
// of the ATiM used (aliquot previously
// transferred from bank different than PS3 to 'Processing Site' and now merged into the ATiM of PS3) can not be defined as the children of an aliquot (realiquoting definition).
$newExcludedAliquot = false;
foreach ($this->request->data as $tmpProcureKey1 => $tmpProcureNewDataSet) {
    foreach ($tmpProcureNewDataSet['children'] as $tmpProcureKey2 => $tmpProcureNewChildrenAliquotRecord) {
        if ($tmpProcureNewChildrenAliquotRecord['SampleMaster']['procure_created_by_bank'] == 's' && $tmpProcureNewChildrenAliquotRecord['AliquotMaster']['procure_created_by_bank'] != Configure::read('procure_bank_id')) {
            unset($this->request->data[$tmpProcureKey1]['children'][$tmpProcureKey2]);
        }
    }
    if (empty($this->request->data[$tmpProcureKey1]['children'])) {
        $excludedParentAliquot[] = $this->request->data[$tmpProcureKey1]['parent'];
        unset($this->request->data[$tmpProcureKey1]);
        $newExcludedAliquot = true;
    }
}
if ($newExcludedAliquot) {
    $tmpBarcode = array();
    foreach ($excludedParentAliquot as $newAliquot) {
        $tmpBarcode[] = $newAliquot['AliquotMaster']['barcode'];
    }
    $msg = __('no new aliquot could be actually defined as realiquoted child for the following parent aliquot(s)') . ': [' . implode(",", $tmpBarcode) . ']';
    
    if (empty($this->request->data)) {
        $this->atimFlashError(__($msg), "javascript:history.back()", 5);
        return;
    } else {
        AppController::addWarningMsg($msg);
    }
}