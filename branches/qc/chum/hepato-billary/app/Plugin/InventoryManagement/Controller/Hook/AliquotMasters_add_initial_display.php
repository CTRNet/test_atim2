<?php
$customOverrideData = array();
foreach ($this->request->data as &$newDataSet) {
    $tmp = array();
    
    $tmp['AliquotMaster.aliquot_label'] = $this->AliquotMaster->generateDefaultAliquotLabel($newDataSet['parent']['ViewSample']['sample_master_id'], $aliquotControl);
    if (! in_array($newDataSet['parent']['ViewSample']['sample_type'], array(
        'dna',
        'rna'
    )))
        $tmp['AliquotMaster.qc_hb_stored_by'] = 'louise rousseau';
    
    if (($newDataSet['parent']['ViewSample']['sample_type'] == 'tissue') && ($aliquotControl['AliquotControl']['aliquot_type'] == 'tube')) {
        $tmp['AliquotDetail.qc_hb_storage_method'] = 'snap frozen';
    }
    if (($newDataSet['parent']['ViewSample']['sample_type'] == 'tissue') && ($aliquotControl['AliquotControl']['aliquot_type'] == 'block')) {
        $tmp['AliquotDetail.block_type'] = 'OCT';
    }
    
    $customOverrideData[$newDataSet['parent']['ViewSample']['sample_master_id']] = $tmp;
}
$this->set('customOverrideData', $customOverrideData);