<?php
	
	$default_aliquot_data = array();
	foreach($this->request->data as &$new_data_set){
		$tmp_default_aliquot_data = array();
		
		if($parent_aliquots[0]['SampleControl']['sample_type'] == 'tissue' && $parent_aliquot_ctrl['AliquotControl']['aliquot_type'] == 'tube' && $child_aliquot_ctrl['AliquotControl']['aliquot_type'] == 'block') {
			$tmp_default_aliquot_data['AliquotMaster.aliquot_label'] = $new_data_set['parent']['AliquotMaster']['aliquot_label'];
			$tmp_default_aliquot_data['AliquotMaster.qcroc_barcode'] = $new_data_set['parent']['AliquotMaster']['qcroc_barcode'];
		
		} else if($parent_aliquots[0]['SampleControl']['sample_type'] == 'tissue' && $parent_aliquot_ctrl['AliquotControl']['aliquot_type'] == 'block' && $child_aliquot_ctrl['AliquotControl']['aliquot_type'] == 'slide') {
			$tmp_default_aliquot_data['AliquotMaster.aliquot_label'] = $new_data_set['parent']['AliquotMaster']['aliquot_label'];
			$tmp_default_aliquot_data['AliquotMaster.qcroc_barcode'] = $new_data_set['parent']['AliquotMaster']['qcroc_barcode'];
		
		} else if($parent_aliquots[0]['SampleControl']['sample_type'] == 'tissue' && $parent_aliquot_ctrl['AliquotControl']['aliquot_type'] == 'block' && $child_aliquot_ctrl['AliquotControl']['aliquot_type'] == 'block') {
			$tmp_default_aliquot_data['AliquotMaster.aliquot_label'] = $new_data_set['parent']['AliquotMaster']['aliquot_label'].'-?';
			$tmp_default_aliquot_data['AliquotMaster.qcroc_barcode'] = $new_data_set['parent']['AliquotMaster']['qcroc_barcode'];
			$new_data_set['children'][] = array('AliquotMaster' => array('aliquot_label' => $new_data_set['parent']['AliquotMaster']['aliquot_label'].'-T'));
			$new_data_set['children'][] = array('AliquotMaster' => array('aliquot_label' => $new_data_set['parent']['AliquotMaster']['aliquot_label'].'-N'));
		}
		
		$default_aliquot_data[$new_data_set['parent']['AliquotMaster']['id']] = $tmp_default_aliquot_data;

	}
	$this->set('default_aliquot_data', $default_aliquot_data);
	