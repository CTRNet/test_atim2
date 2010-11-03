<?php
 
 	// --------------------------------------------------------------------------------
	// Set Default Aliquot Barcode
	// -------------------------------------------------------------------------------- 	
	if(empty($this->data)) {
		if($aliquot_control_data['AliquotControl']['aliquot_type'] == 'whatman paper') {
			$inital_data[0]['AliquotMaster']['barcode'] = substr($sample_data['SampleMaster']['qc_cusm_sample_label'], 0 , strrpos($sample_data['SampleMaster']['qc_cusm_sample_label'], '-')) . '-WHT';
		} else if($aliquot_control_data['AliquotControl']['aliquot_type'] == 'block') {
			$default_storage_date = $this->getDefaultAliquotStorageDate($sample_data);
			$inital_data = array(
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
		}else {
			$inital_data[0]['AliquotMaster']['barcode'] = $sample_data['SampleMaster']['qc_cusm_sample_label'];
		}
	}
	
?>