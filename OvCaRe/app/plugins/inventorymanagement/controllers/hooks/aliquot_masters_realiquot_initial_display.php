<?php
	
	$default_aliquot_data = array();
	foreach($this->data as $new_data_set){
		$sample_master_id = $new_data_set['parent']['AliquotMaster']['sample_master_id'];
		$default_aliquot_data[$sample_master_id] = array('aliquot_label' => 'n/a');
		
		if($child_aliquot_ctrl['AliquotControl']['aliquot_type'] == 'block') {
			if($new_data_set['parent']['SampleControl']['sample_type'] != 'tissue') $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			$default_aliquot_data[$sample_master_id]['block_type'] = 'paraffin';	
			
		}
	}
	$this->set('default_aliquot_data', $default_aliquot_data);
	
?>
