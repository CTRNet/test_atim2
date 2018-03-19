<?php

// --------------------------------------------------------------------------------
// Set default aliquot label(s)
// --------------------------------------------------------------------------------
$default_aliquot_labels = array();
foreach ($this->data as $new_data_set) {
    $default_aliquot_label = $this->AliquotMaster->generateDefaultAliquotLabel($new_data_set['parent']['ViewAliquot']);
    $default_aliquot_labels[$new_data_set['parent']['ViewAliquot']['sample_master_id']] = $default_aliquot_label;
}
$this->set('default_aliquot_labels', $default_aliquot_labels);

?>
