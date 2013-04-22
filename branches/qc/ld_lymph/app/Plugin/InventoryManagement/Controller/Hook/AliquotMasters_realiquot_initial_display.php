<?php
	
	// --------------------------------------------------------------------------------
	// Set default aliquot label(s)
	// -------------------------------------------------------------------------------- 	
	$default_aliquot_data = array();
	foreach($this->request->data as $new_data_set){
		if(!isset($new_data_set['parent']['SampleMaster']['ld_lymph_specimen_number'])) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		$sample_master_id = $new_data_set['parent']['AliquotMaster']['sample_master_id'];
		$default_aliquot_data[$sample_master_id] = array('barcode' => $new_data_set['parent']['SampleMaster']['ld_lymph_specimen_number'].'-');
	}
	$this->set('default_aliquot_data', $default_aliquot_data);
	