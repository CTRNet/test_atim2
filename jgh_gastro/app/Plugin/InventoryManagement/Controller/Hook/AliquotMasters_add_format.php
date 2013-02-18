<?php
	
	// --------------------------------------------------------------------------------
	// Set default aliquot barcode(s)
	// --------------------------------------------------------------------------------
	$default_aliquot_barcodes = array();
	foreach($samples as $view_sample){
		$default_aliquot_barcode = $this->AliquotMaster->generateDefaultAliquotBarcode($view_sample, $aliquot_control);
		$default_aliquot_barcodes[$view_sample['ViewSample']['sample_master_id']] = $default_aliquot_barcode;
	}
	$this->set('default_aliquot_barcodes', $default_aliquot_barcodes);
	
?>
