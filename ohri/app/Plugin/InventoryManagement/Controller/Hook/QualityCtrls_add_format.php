<?php

// --------------------------------------------------------------------------------
// Set Default Run Id
// --------------------------------------------------------------------------------
foreach ($this->request->data as $key => $newSample) {
    $defaultRunId = $newSample['parent']['ViewSample']['sample_code'] . ' / ' . date('Y-m-d');
    $this->request->data[$key]['children']['0']['QualityCtrl']['run_id'] = $defaultRunId;
}