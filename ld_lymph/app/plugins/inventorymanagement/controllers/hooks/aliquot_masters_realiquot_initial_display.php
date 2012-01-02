<?php
 	
	// --------------------------------------------------------------------------------
	// Set Default Aliquot Data
	// -------------------------------------------------------------------------------- 	
	$custom_override_data = array();	
	foreach($this->data as &$new_data_set) {
		if(!isset($new_data_set['parent']['SampleMaster']['ld_lymph_specimen_number'])) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		$tmp = array();
		$tmp['AliquotMaster.barcode'] = $new_data_set['parent']['SampleMaster']['ld_lymph_specimen_number'].'-';
			
		$custom_override_data[$new_data_set['parent']['AliquotMaster']['id']] = $tmp;
	}
	$this->set('custom_override_data', $custom_override_data);
	
	