<?php

// --------------------------------------------------------------------------------
// Set default aliquot data
// --------------------------------------------------------------------------------
$procure_default_aliquot_data = array();
$processing_site_last_barcode = null;
foreach ($this->request->data as $tmp_key => &$new_data_set) {
    $sample_master_id = $new_data_set['parent']['AliquotMaster']['sample_master_id'];
    if (in_array($new_data_set['parent']['ViewAliquot']['sample_type'], array(
        'rna',
        'dna'
    )))
        $procure_default_aliquot_data[$sample_master_id]['AliquotDetail.concentration_unit'] = 'ng/ul';
    $procure_default_aliquot_data[$sample_master_id]['AliquotMaster.barcode'] = $new_data_set['parent']['AliquotMaster']['barcode'];
}
$this->set('procure_default_aliquot_data', $procure_default_aliquot_data);
	