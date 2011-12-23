<?php

foreach($this->data as &$new_data_set) {
	$new_data_set['children'][0]['AliquotMaster']['aliquot_label'] = $this->AliquotMaster->generateDefaultAliquotLabel($new_data_set['parent']['ViewSample']['sample_master_id'], $aliquot_control);
	$new_data_set['children'][0]['AliquotMaster']['qc_hb_stored_by'] = 'louise rousseau';
	
	if(($new_data_set['parent']['ViewSample']['sample_type'] == 'tissue') && ($aliquot_control['AliquotControl']['aliquot_type'] == 'tube')) {
		$new_data_set['children'][0]['AliquotDetail']['qc_hb_storage_method'] = 'snap frozen';
	}
	if(($new_data_set['parent']['ViewSample']['sample_type'] == 'tissue') && ($aliquot_control['AliquotControl']['aliquot_type'] == 'block')) {
		$new_data_set['children'][0]['AliquotDetail']['block_type'] = 'OCT';
	}
}

?>