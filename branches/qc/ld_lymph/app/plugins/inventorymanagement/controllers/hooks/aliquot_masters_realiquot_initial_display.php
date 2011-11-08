<?php
 	
	foreach($this->data as &$new_data_set) {
		if(!isset($new_data_set['parent']['SampleMaster']['ld_lymph_specimen_number'])) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		$ld_lymph_specimen_number = $new_data_set['parent']['SampleMaster']['ld_lymph_specimen_number'];	
		if(!isset($new_data_set['children'][0])) $new_data_set['children'][0] = array();
		foreach($new_data_set['children'] as &$new_aliquot) {
			$new_aliquot['AliquotMaster']['barcode'] = $ld_lymph_specimen_number.'-';
		}
	}
	