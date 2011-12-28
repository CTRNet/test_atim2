<?php

	$custom_override_data = array();	
	foreach($this->data as &$new_data_set) {
		$tmp = array();
		
		$tmp['AliquotMaster.aliquot_label'] = $new_data_set['parent']['AliquotMaster']['aliquot_label'];
		$tmp['AliquotMaster.qc_hb_stored_by'] = 'louise rousseau';
		$tmp['Realiquoting.realiquoted_by'] = 'louise rousseau';
		
		if(($new_data_set['parent']['SampleControl']['sample_type'] == 'tissue') && ($child_aliquot_ctrl['AliquotControl']['aliquot_type'] == 'tube')) {
			$tmp['AliquotDetail.qc_hb_storage_method'] = 'snap frozen';
		}
		if(($new_data_set['parent']['SampleControl']['sample_type'] == 'tissue') && ($child_aliquot_ctrl['AliquotControl']['aliquot_type'] == 'block')) {
			$tmp['AliquotDetail.block_type'] = 'OCT';
		}
	
		$custom_override_data[$new_data_set['parent']['AliquotMaster']['id']] = $tmp;
	}
	$this->set('custom_override_data', $custom_override_data);

?>