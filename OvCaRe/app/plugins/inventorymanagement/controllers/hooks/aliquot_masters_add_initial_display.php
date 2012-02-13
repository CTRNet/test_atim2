<?php
		
	$default_aliquot_data = array();
	foreach($samples as $view_sample){
		$default_aliquot_data[$view_sample['ViewSample']['sample_master_id']] = array('aliquot_label' => 'n/a');
		
		if($aliquot_control['AliquotControl']['aliquot_type'] == 'block') {
			if($view_sample['ViewSample']['sample_type'] != 'tissue') $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			$default_aliquot_data[$view_sample['ViewSample']['sample_master_id']]['block_type'] = 'paraffin';
		}
	}
	$this->set('default_aliquot_data', $default_aliquot_data);

?>
