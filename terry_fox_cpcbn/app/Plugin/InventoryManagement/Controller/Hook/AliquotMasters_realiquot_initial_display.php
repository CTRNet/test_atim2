<?php

// --------------------------------------------------------------------------------
// Set default aliquot label(s)
// --------------------------------------------------------------------------------
$defaultAliquotLabels = array();
foreach ($this->request->data as &$newDataSet) {
    $defaultAliquotLabel = $this->AliquotMaster->generateDefaultAliquotLabel($newDataSet['parent']['ViewAliquot'], $childAliquotCtrl);
    $defaultAliquotLabels[$newDataSet['parent']['ViewAliquot']['sample_master_id']] = $defaultAliquotLabel;
    if ($newDataSet['parent']['ViewAliquot']['sample_type'] == 'tissue' && $childAliquotCtrl['AliquotControl']['aliquot_type'] == 'slide') {
        $slideCounter = 0;
        foreach ($newDataSet['children'] as &$newChild) {
            $slideCounter ++;
            $newChild['AliquotMaster']['aliquot_label'] = "$defaultAliquotLabel - $slideCounter";
        }
    }
}