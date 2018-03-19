<?php

// --------------------------------------------------------------------------------
// Set default aliquot label(s)
// --------------------------------------------------------------------------------
$defaultAliquotLabels = array();
foreach ($this->data as $newDataSet) {
    $defaultAliquotLabel = $this->AliquotMaster->generateDefaultAliquotLabel($newDataSet['parent']['ViewAliquot']);
    $defaultAliquotLabels[$newDataSet['parent']['ViewAliquot']['sample_master_id']] = $defaultAliquotLabel;
}
$this->set('defaultAliquotLabels', $defaultAliquotLabels);