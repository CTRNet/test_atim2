<?php
	
	$tissue_suffixes = null;
	if($aliquot_control['AliquotControl']['aliquot_type'] == 'tube') {
		$tissue_suffixes = array_slice(range('a', 'z'), 0, 24);
	} else if($aliquot_control['AliquotControl']['aliquot_type'] == 'block'){
		$tissue_suffixes = array_slice(range('A', 'Z'), 0, 24);
	}
	$default_aliquot_data = array();
	//Get last box used
	$last_aliquot_created = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.aliquot_control_id' => $aliquot_control['AliquotControl']['id'], 'AliquotMaster.storage_master_id IS NOT NULL', "AliquotMaster.storage_master_id NOT LIKE ''"), 'order' => 'AliquotMaster.modified DESC', 'recursive' => '0'));
	$default_selection_label = $last_aliquot_created? $last_aliquot_created['StorageMaster']['selection_label']: '';
	foreach($this->request->data as &$new_data_set){	
		$view_sample = $new_data_set['parent'];
		$tmp_default_aliquot_data = array('AliquotMaster.ovcare_clinical_aliquot' => 'no');
		$tmp_default_aliquot_data['FunctionManagement.recorded_storage_selection_label'] = $default_selection_label;
		$suffix = '';
		switch($view_sample['ViewSample']['sample_type']) {
			case 'blood cell':
				$suffix = 'BC';
				$tmp_default_aliquot_data['AliquotMaster.initial_volume'] = '1.0';
				break;
			case 'plasma':
				$suffix = 'P';
				$tmp_default_aliquot_data['AliquotMaster.initial_volume'] = '1.8';
				$tmp_default_aliquot_data['AliquotDetail.hemolysis_signs'] = 'n';
				break;
			case 'serum':
				$suffix = 'S';
				$tmp_default_aliquot_data['AliquotMaster.initial_volume'] = '1.8';
				$tmp_default_aliquot_data['AliquotDetail.hemolysis_signs'] = 'n';
				break;
			case 'ascite':
				$suffix = 'Ascites';
				break;
			case 'saliva':
				$suffix = 'Saliva';
				break;
			case 'tissue':
				if($tissue_suffixes) {
					$key = 0;
					foreach($new_data_set['children'] as &$new_aliquot) {
						$new_aliquot['AliquotMaster']['aliquot_label'] = 'VOA'.$view_sample['ViewSample']['ovcare_collection_voa_nbr'].$tissue_suffixes[$key];
						$new_aliquot['AliquotDetail']['ocvare_tissue_section'] = $tissue_suffixes[$key];
						if($key < 24) $key++;				
					}
				}
				if($aliquot_control['AliquotControl']['aliquot_type'] == 'block') {
					if(!isset(AppController::getInstance()->passedArgs['templateInitId'])) $tmp_default_aliquot_data['AliquotDetail.block_type'] = 'paraffin';
				} else if($aliquot_control['AliquotControl']['aliquot_type'] == 'tube') {
					$tmp_default_aliquot_data['AliquotDetail.ovcare_storage_method'] = 'snap frozen';
				}
				break;
		}
		$tmp_default_aliquot_data['AliquotMaster.aliquot_label'] = 'VOA'.$view_sample['ViewSample']['ovcare_collection_voa_nbr'].$suffix;
		$default_aliquot_data[$view_sample['ViewSample']['sample_master_id']] = $tmp_default_aliquot_data;
	}
	$this->set('default_aliquot_data', $default_aliquot_data);
	
?>
