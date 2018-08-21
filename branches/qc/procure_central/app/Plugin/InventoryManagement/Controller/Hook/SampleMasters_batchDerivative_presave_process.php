<?php

// Set data to complete the procure_created_by_bank field
foreach ($prevData as &$children) {
    foreach ($children as &$childToSave) {
        $childToSave['SampleMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
    }
}
$this->SampleMaster->addWritableField(array(
    'procure_created_by_bank'
));

// Manage record of the initial weight of blood tubes
if ($procureTubeWeightsToSave) {
    // Validate initial blood tube weight value and re-set submitted data to display if validation failed
    $recordCounter = 0;
    foreach ($this->request->data as &$procureDataSetToRedisplay) {
        $recordCounter ++;
        if (array_key_exists($procureDataSetToRedisplay['parent']['AliquotMaster']['id'], $procureTubeWeightsToSave)) {
            $procureTubeWeightGr = str_replace(',', '.', $procureTubeWeightsToSave[$procureDataSetToRedisplay['parent']['AliquotMaster']['id']]);
            // Re-set submitted data in case validation failed
            $procureDataSetToRedisplay['parent']['AliquotDetail']['procure_tube_weight_gr'] = $procureTubeWeightGr;
            // Validate procure_tube_weight_gr
            if (strlen($procureTubeWeightGr) && ! preg_match('/^(([0-9]+)|([0-9]*\.[0-9]+))$/', $procureTubeWeightGr)) { // Note: unable to use form validation.
                $errors['procure_tube_weight_gr'][__('error_must_be_positive_float') . ' (' . __('initial tube weight gr') . ')'][$recordCounter] = $recordCounter;
            }
        }
    }
    // Add submitted initial blood tube weights to data to save
    foreach ($aliquotsData as &$aliquotDataToSave) {
        $addWirtableField = false;
        if (array_key_exists($aliquotDataToSave['AliquotMaster']['id'], $procureTubeWeightsToSave)) {
            $aliquotDataToSave['AliquotDetail']['procure_tube_weight_gr'] = $procureTubeWeightsToSave[$aliquotDataToSave['AliquotMaster']['id']];
        }
    }
}