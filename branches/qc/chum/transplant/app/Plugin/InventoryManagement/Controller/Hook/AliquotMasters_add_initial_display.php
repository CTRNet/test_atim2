<?php
if (isset($defaultAliquotLabels)) {
    foreach ($this->request->data as &$newSampleAndAliquots) {
        if ($newSampleAndAliquots['parent']['ViewSample']['bank_id'] == 4) {
            $sampleMasterId = $newSampleAndAliquots['parent']['ViewSample']['sample_master_id'];
            if (array_key_exists($sampleMasterId, $defaultAliquotLabels)) {
                $counter = 0;
                foreach ($newSampleAndAliquots['children'] as &$newAliquot) {
                    $counter ++;
                    $newAliquot['AliquotMaster']['aliquot_label'] = $defaultAliquotLabels[$sampleMasterId] . $counter;
                }
            }
        }
    }
}