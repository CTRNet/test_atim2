<?php

foreach($this->data as &$new_data_set) {
	$new_data_set['children'][0]['AliquotMaster']['aliquot_label'] = $new_data_set['parent']['AliquotMaster']['aliquot_label'];
	$new_data_set['children'][0]['AliquotMaster']['qc_hb_stored_by'] = 'louise rousseau';
	$new_data_set['children'][0]['Realiquoting']['realiquoted_by'] = 'louise rousseau';
	
	if(($new_data_set['parent']['SampleControl']['sample_type'] == 'tissue') && ($child_aliquot_ctrl['AliquotControl']['aliquot_type'] == 'tube')) {
		$new_data_set['children'][0]['AliquotDetail']['qc_hb_storage_method'] = 'snap frozen';
	}
	if(($new_data_set['parent']['SampleControl']['sample_type'] == 'tissue') && ($child_aliquot_ctrl['AliquotControl']['aliquot_type'] == 'block')) {
		$new_data_set['children'][0]['AliquotDetail']['block_type'] = 'OCT';
	}	
}

?>