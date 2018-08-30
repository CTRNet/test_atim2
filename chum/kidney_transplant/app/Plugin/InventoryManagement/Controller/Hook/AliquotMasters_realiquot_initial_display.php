<?php
// --------------------------------------------------------------------------------
// Set default aliquot label(s)
// --------------------------------------------------------------------------------
foreach ($this->data as $newDataSet) {
    $defaultAliquotLabels[$newDataSet['parent']['AliquotMaster']['sample_master_id']] = $newDataSet['parent']['AliquotMaster']['aliquot_label'];;
}
$this->set('defaultAliquotLabels', $defaultAliquotLabels);