<?php
		
	$default_aliquot_data = array();
	foreach($samples as $view_sample){
		if(!isset($view_sample['ViewSample']['ld_lymph_specimen_number'])) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		$default_aliquot_data[$view_sample['ViewSample']['sample_master_id']] = array('barcode' => $view_sample['ViewSample']['ld_lymph_specimen_number'].'-');
	}
	$this->set('default_aliquot_data', $default_aliquot_data);
