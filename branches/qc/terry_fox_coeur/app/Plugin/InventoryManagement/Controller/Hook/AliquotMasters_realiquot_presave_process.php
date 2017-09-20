<?php

// --------------------------------------------------------------------------------
// Set default aliquot label(s)
// --------------------------------------------------------------------------------
if (! empty($errors)) {
    foreach ($this->data as $newDataSet) {
        $sampleMasterId = $newDataSet['parent']['AliquotMaster']['sample_master_id'];
        $sampleData = $this->ViewSample->find('first', array(
            'conditions' => array(
                'sample_master_id' => $sampleMasterId
            ),
            'recursive' => - 1
        ));
        $defaultAliquotLabel = $this->AliquotMaster->generateDefaultAliquotLabel($sampleData, $childAliquotCtrl);
        $defaultAliquotLabels[$sampleMasterId] = $defaultAliquotLabel;
    }
    $this->set('defaultAliquotLabels', $defaultAliquotLabels);
}