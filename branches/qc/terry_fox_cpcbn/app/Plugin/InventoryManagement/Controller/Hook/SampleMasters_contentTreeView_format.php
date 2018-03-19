<?php
if (! $sampleMasterId) {
    $arrayToSort = array();
    foreach ($this->request->data as $tmpNewSample)
        $arrayToSort[strtolower($tmpNewSample['SampleMaster']['qc_tf_tma_sample_control_code'])][] = $tmpNewSample;
    $this->request->data = array();
    ksort($arrayToSort);
    foreach ($arrayToSort as $tmpNewSampleLevel1) {
        foreach ($tmpNewSampleLevel1 as $tmpNewSampleLevel2) {
            $this->request->data[] = $tmpNewSampleLevel2;
        }
    }
}