<?php
	
	$tissue_suffixes = null;
	if($aliquot_control['AliquotControl']['aliquot_type'] == 'tube') {
		$tissue_suffixes = array_slice(range('a', 'z'), 0, 24);
	} else if($aliquot_control['AliquotControl']['aliquot_type'] == 'block'){
		$tissue_suffixes = array_slice(range('A', 'Z'), 0, 24);
	}
	$default_aliquot_data = array();
	foreach($this->request->data as &$new_data_set){	
		$view_sample = $new_data_set['parent'];
		//Default_aliquot_data
		$suffix = '';
		switch($view_sample['ViewSample']['sample_type']) {
			case 'blood cell':
				$suffix = 'BC';
				break;
			case 'plasma':
				$suffix = 'P';
				break;
			case 'serum':
				$suffix = 'S';
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
						$new_aliquot['AliquotMaster']['aliquot_label'] = 'VOA'.$view_sample['ViewSample']['collection_voa_nbr'].$tissue_suffixes[$key];
						if($key < 24) $key++;				
					}
				}
				break;
		}	
		$default_aliquot_data[$view_sample['ViewSample']['sample_master_id']] = array('aliquot_label' => 'VOA'.$view_sample['ViewSample']['collection_voa_nbr'].$suffix);
		//Default Aliquot Block
		if($view_sample['ViewSample']['sample_type'] == 'tissue' && $aliquot_control['AliquotControl']['aliquot_type'] == 'block') {
			$default_aliquot_data[$view_sample['ViewSample']['sample_master_id']]['block_type'] = 'paraffin';
		}
	}
	$this->set('default_aliquot_data', $default_aliquot_data);
	
?>
