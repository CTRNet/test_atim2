<?php
if (isset($customOverrideData) && array_key_exists($data['parent']['ViewSample']['sample_master_id'], $customOverrideData)) {
    $finalOptionsChildren['override'] = array_merge($finalOptionsChildren['override'], $customOverrideData[$data['parent']['ViewSample']['sample_master_id']]);
}