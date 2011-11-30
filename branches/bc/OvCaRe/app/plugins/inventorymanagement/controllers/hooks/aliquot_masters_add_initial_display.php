<?php
	
	// --------------------------------------------------------------------------------
	// Set default tissue block type
	// -------------------------------------------------------------------------------- 	
	if($aliquot_control['AliquotControl']['aliquot_type'] == 'block') {
		foreach($this->data as &$new_data_set) {
			if($new_data_set['parent']['ViewSample']['sample_type'] != 'tissue') $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			$new_data_set['children'][0]['AliquotDetail']['block_type'] = 'paraffin';			
		}
	}

?>
