<?php

// --------------------------------------------------------------------------------
// Set default aliquot data
// --------------------------------------------------------------------------------
$procureDefaultAliquotData = array();
$processingSiteLastBarcode = null;
foreach ($this->request->data as $tmpKey => &$newDataSet) {
    $sampleMasterId = $newDataSet['parent']['AliquotMaster']['sample_master_id'];
    if (in_array($newDataSet['parent']['ViewAliquot']['sample_type'], array(
        'rna',
        'dna'
    )))
        $procureDefaultAliquotData[$sampleMasterId]['AliquotDetail.concentration_unit'] = 'ng/ul';
    $procureDefaultAliquotData[$sampleMasterId]['AliquotMaster.barcode'] = $newDataSet['parent']['AliquotMaster']['barcode'];
}
$this->set('procureDefaultAliquotData', $procureDefaultAliquotData);