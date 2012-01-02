<?php
 
 	// --------------------------------------------------------------------------------
	// Set Default Aliquot Data
	// -------------------------------------------------------------------------------- 	
	$custom_override_data = array();	
	foreach($this->data as &$new_data_set) {
		$tmp = array();
		$tmp['AliquotMaster.aliquot_label'] = $new_data_set['parent']['AliquotMaster']['aliquot_label'];
			
		$custom_override_data[$new_data_set['parent']['AliquotMaster']['id']] = $tmp;
	}
	$this->set('custom_override_data', $custom_override_data);
	
?>