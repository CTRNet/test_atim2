<?php
if (isset($defaultAliquotLabels)) {
    foreach ($this->request->data as &$newSampleAndAliquots) {
        if (in_array($newSampleAndAliquots['parent']['ViewSample']['bank_id'], array('4', '10'))) {
            $sampleMasterId = $newSampleAndAliquots['parent']['ViewSample']['sample_master_id'];
            if (array_key_exists($sampleMasterId, $defaultAliquotLabels)) {
                $counter = 0;
                foreach ($newSampleAndAliquots['children'] as &$newAliquot) {
                    $counter ++;
                    if($newSampleAndAliquots['parent']['ViewSample']['bank_id'] == 4) {
                        $newAliquot['AliquotMaster']['aliquot_label'] = $defaultAliquotLabels[$sampleMasterId] . $counter;
                    } else {
                        $newAliquot['AliquotMaster']['aliquot_label'] = str_replace('-? ', "-$counter ", $defaultAliquotLabels[$sampleMasterId]);
                    }
                }
            }
        }
    }
}