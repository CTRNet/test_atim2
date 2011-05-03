<?php
	
	// --------------------------------------------------------------------------------
	// Set default aliquot barcode(s)
	// -------------------------------------------------------------------------------- 	
	foreach($this->data as $new_data_set){
		$aliquot_master_id = $new_data_set['parent']['AliquotMaster']['id'];
		$default_aliquot_barcodes[$aliquot_master_id] = $new_data_set['parent']['AliquotMaster']['barcode'].'?';
	}
	$this->set('default_aliquot_barcodes', $default_aliquot_barcodes);
	
?>
