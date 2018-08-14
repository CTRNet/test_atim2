<?php
$tmpSampleMasterId = $data['parent']['ViewSample']['sample_master_id'];
if (isset($defaultAliquotData[$tmpSampleMasterId])) {
    foreach ($defaultAliquotData[$tmpSampleMasterId] as $field => $value)
        $finalOptionsChildren['override'][$field] = $value;
}