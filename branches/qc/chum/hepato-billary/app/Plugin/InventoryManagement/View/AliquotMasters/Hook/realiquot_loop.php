<?php
if (isset($customOverrideData) && array_key_exists($data['parent']['AliquotMaster']['id'], $customOverrideData)) {
    $finalOptionsChildren['override'] = array_merge($finalOptionsChildren['override'], $customOverrideData[$data['parent']['AliquotMaster']['id']]);
}