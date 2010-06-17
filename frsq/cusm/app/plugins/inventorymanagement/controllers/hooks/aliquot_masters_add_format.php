<?php
 
 	// --------------------------------------------------------------------------------
	// Set Default Aliquot Barcode
	// -------------------------------------------------------------------------------- 	
	if(empty($this->data)) {
		$default_aliquot_barcode = '';
		if($aliquot_control_data['AliquotControl']['aliquot_type'] == 'whatman paper') {
			$default_aliquot_barcode = substr($sample_data['SampleMaster']['qc_cusm_sample_label'], 0 , strrpos($sample_data['SampleMaster']['qc_cusm_sample_label'], '-')) . '-WHT';
		} else if($aliquot_control_data['AliquotControl']['aliquot_type'] == 'block') {
			$default_aliquot_barcode = '';
		}else {
			$default_aliquot_barcode = $sample_data['SampleMaster']['qc_cusm_sample_label'];
		}
		$this->set('default_aliquot_barcode', $default_aliquot_barcode);
	}
	
 	// --------------------------------------------------------------------------------
	// Create default blocks for initial display
	//
	// (Custom code has been set in this file because there is a bug with data override 
	// in view: see eventum issue #958) 
	// -------------------------------------------------------------------------------- 	
	$this->set_default_block_display = false;
	if(empty($this->data) && ($aliquot_control_data['AliquotControl']['aliquot_type'] == 'block')) {	
		$this->set_default_block_display = true;
		
		// Set data for initial display
		$default_storage_date = $this->getDefaultAliquotStorageDate($sample_data);
		$this->data = array(
			array(
				'AliquotMaster' => array(
					'barcode' => $sample_data['SampleMaster']['qc_cusm_sample_label'] . ' -FRZ',
					'aliquot_type' => $aliquot_control_data['AliquotControl']['aliquot_type'],
					'aliquot_volume_unit' => $aliquot_control_data['AliquotControl']['volume_unit'],
					'storage_datetime' =>$default_storage_date),
				'AliquotDetail' => array(
					'block_type' => 'OCT')),
			array(
				'AliquotMaster' => array(
					'barcode' => $sample_data['SampleMaster']['qc_cusm_sample_label'] . ' -FFPE',
					'aliquot_type' => $aliquot_control_data['AliquotControl']['aliquot_type'],
					'aliquot_volume_unit' => $aliquot_control_data['AliquotControl']['volume_unit'],
					'storage_datetime' =>$default_storage_date),
				'AliquotDetail' => array(
					'block_type' => 'paraffin')));			
	}
	
?>