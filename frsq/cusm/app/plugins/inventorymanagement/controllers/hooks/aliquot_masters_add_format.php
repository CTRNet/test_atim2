<?php
 
 	// --------------------------------------------------------------------------------
	// Set Default Aliquot Barcode
	// -------------------------------------------------------------------------------- 	
	if(empty($this->data)) {
		$default_aliquot_barcode = '';
		if($aliquot_control_data['AliquotControl']['aliquot_type'] == 'whatman paper') {
			$default_aliquot_barcode = substr($sample_data['SampleMaster']['sample_label'], 0 , strrpos($sample_data['SampleMaster']['sample_label'], '-')) . '-WHT';
		} else {
			$default_aliquot_barcode = $sample_data['SampleMaster']['sample_label'];
		}
		$this->set('default_aliquot_barcode', $default_aliquot_barcode);
	}
	
?>
