<?php
	
	// --------------------------------------------------------------------------------
	// Set default aliquot barcode(s)
	// -------------------------------------------------------------------------------- 	
	foreach($this->data as $new_data_set){
		$sample_master_id = $new_data_set['parent']['AliquotMaster']['sample_master_id'];
		$default_aliquot_barcode = $new_data_set['parent']['AliquotMaster']['barcode'];
		$default_aliquot_barcodes[$sample_master_id] = $default_aliquot_barcode;
	}
	$this->set('default_aliquot_barcodes', $default_aliquot_barcodes);
	
?>
