<?php
$customOverrideData = array();
foreach ($this->request->data as &$newDataSet) {
    $tmp = array();
    $tmp['AliquotMaster.aliquot_label'] = $this->AliquotMaster->generateDefaultAliquotLabel($newDataSet['parent']['ViewSample']['sample_master_id'], $aliquotControl);
    if (! isset(AppController::getInstance()->passedArgs['templateInitId'])) {
        if (! in_array($newDataSet['parent']['ViewSample']['sample_type'], array(
            'dna',
            'rna'
        ))) {
            $tmp['AliquotMaster.qc_hb_stored_by'] = 'louise rousseau';
        }
    }
    $customOverrideData[$newDataSet['parent']['ViewSample']['sample_master_id']] = $tmp;
}
$this->set('customOverrideData', $customOverrideData);