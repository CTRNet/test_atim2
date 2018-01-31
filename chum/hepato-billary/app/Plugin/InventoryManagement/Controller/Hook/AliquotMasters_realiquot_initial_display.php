<?php
$customOverrideData = array();
foreach ($this->request->data as &$newDataSet) {
    $tmp = array();
    
    $tmp['AliquotMaster.aliquot_label'] = $newDataSet['parent']['AliquotMaster']['aliquot_label'];
    if (! in_array($newDataSet['parent']['SampleControl']['sample_type'], array(
        'dna',
        'rna'
    )))
        $tmp['AliquotMaster.qc_hb_stored_by'] = 'louise rousseau';
    $tmp['Realiquoting.realiquoted_by'] = 'louise rousseau';
    
    if (($newDataSet['parent']['SampleControl']['sample_type'] == 'tissue') && ($childAliquotCtrl['AliquotControl']['aliquot_type'] == 'tube')) {
        $tmp['AliquotDetail.qc_hb_storage_method'] = 'snap frozen';
    }
    if (($newDataSet['parent']['SampleControl']['sample_type'] == 'tissue') && ($childAliquotCtrl['AliquotControl']['aliquot_type'] == 'block')) {
        $tmp['AliquotDetail.block_type'] = 'OCT';
    }
    
    $customOverrideData[$newDataSet['parent']['AliquotMaster']['id']] = $tmp;
}
$this->set('customOverrideData', $customOverrideData);