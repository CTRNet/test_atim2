<?php
if (! $sampleMasterId) {
    $arrayToSort = array();
    foreach ($this->request->data as $tmpNewSample)
        $arrayToSort[strtolower($tmpNewSample['SampleMaster']['qbcf_tma_sample_control_code'])][] = $tmpNewSample;
    $this->request->data = array();
    ksort($arrayToSort);
    foreach ($arrayToSort as $tmpNewSampleLevel1) {
        foreach ($tmpNewSampleLevel1 as $tmpNewSampleLevel2) {
            $this->request->data[] = $tmpNewSampleLevel2;
        }
    }
} else {
    foreach ($this->request->data as &$tmpQbcfData) {
        if (isset($tmpQbcfData['AliquotControl'])) {
            if ($tmpQbcfData['AliquotControl']['databrowser_label'] == 'tissue|block' && array_key_exists('qbcf_block_selected', $tmpQbcfData['AliquotDetail'])) {
                $tmpQbcfData['Generated']['qbcf_block_selected'] = '-' . __('selected') . ' : ' . (empty($tmpQbcfData['AliquotDetail']['qbcf_block_selected']) ? __('unknown') : __($tmpQbcfData['AliquotDetail']['qbcf_block_selected']));
            } else {
                $tmpQbcfData['Generated']['qbcf_block_selected'] = '';
            }
        }
    }
}