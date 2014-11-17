<?php
	
	// --------------------------------------------------------------------------------
	// Set default aliquot label(s)
	// -------------------------------------------------------------------------------- 	
	$default_aliquot_data = array();
	foreach($this->data as $new_data_set){	
		$sample_master_id = $new_data_set['parent']['AliquotMaster']['sample_master_id'];
		$default_aliquot_data[$sample_master_id] = array(
			'AliquotMaster.aliquot_label' => $new_data_set['parent']['AliquotMaster']['aliquot_label'],
			'AliquotMaster.ovcare_clinical_aliquot' => 'no'
		);
		switch($new_data_set['parent']['SampleControl']['sample_type']) {
			case 'tissue':
				if($child_aliquot_ctrl['AliquotControl']['aliquot_type'] == 'block') {
					$default_aliquot_data[$sample_master_id]['AliquotDetail.block_type'] = 'paraffin';
				} else 	if($child_aliquot_ctrl['AliquotControl']['aliquot_type'] == 'tube') {
					$default_aliquot_data[$sample_master_id]['AliquotDetail.ovcare_storage_method'] = 'snap frozen';
				}
				break;
			case 'blood cell':
				$default_aliquot_data[$sample_master_id]['AliquotMaster.initial_volume'] = '1.0';
				break;
			case 'plasma':
				$default_aliquot_data[$sample_master_id]['AliquotMaster.initial_volume'] = '1.8';
				break;
			case 'serum':
				$default_aliquot_data[$sample_master_id]['AliquotMaster.initial_volume'] = '1.8';
				break;	
		}
		if(isset($new_data_set['parent']['AliquotDetail']['ocvare_tissue_section'])) $default_aliquot_data[$sample_master_id]['AliquotDetail.ocvare_tissue_section'] = $new_data_set['parent']['AliquotDetail']['ocvare_tissue_section'];
	}
	$this->set('default_aliquot_data', $default_aliquot_data);
	
?>
