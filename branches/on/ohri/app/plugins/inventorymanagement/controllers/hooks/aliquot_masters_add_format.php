<?php
 
 	// --------------------------------------------------------------------------------
	// Set Default Aliquot Data
	// -------------------------------------------------------------------------------- 	
	
	if(empty($this->data)) {
		switch($sample_data['SampleMaster']['sample_type']) {
			case 'ascite supernatant':
				$inital_data[0]['AliquotMaster']['initial_volume'] = '15';
				break;
			case 'ascite cell':
				$inital_data[0]['AliquotMaster']['initial_volume'] = '1';
				$inital_data[1] = $inital_data[0];
				$inital_data[0]['AliquotDetail']['ohri_storage_method'] = 'flash frozen';
				$inital_data[1]['AliquotDetail']['ohri_storage_solution'] = 'dmso';
				break;
			case 'cell culture':				
				$inital_data[0]['AliquotMaster']['initial_volume'] = '1';
				break;
				
			case 'tissue':
				if($aliquot_control_data['AliquotControl']['aliquot_type'] == 'block') {
					$inital_data[0]['AliquotDetail']['block_type'] = 'paraffin';
				} else if($aliquot_control_data['AliquotControl']['aliquot_type'] == 'tube') {
					$inital_data[0]['AliquotDetail']['ohri_storage_method'] = 'flash frozen';
				}
				break;
				
			default:
		}
	}
	
?>