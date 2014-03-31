<?php
	
	// --------------------------------------------------------------------------------
	// Set default aliquot barcode(s)
	// -------------------------------------------------------------------------------- 
	$default_aliquot_barcodes = array();
	foreach($this->data as $new_data_set){
		$sample_master_id = $new_data_set['parent']['AliquotMaster']['sample_master_id'];
		$sample_data = $this->ViewSample->find('first', array('conditions' => array('sample_master_id' => $sample_master_id), 'recursive' => -1));
		$default_aliquot_barcode = $this->AliquotMaster->generateDefaultAliquotBarcode($sample_data, $child_aliquot_ctrl);
		$default_aliquot_barcodes[$sample_master_id] = $default_aliquot_barcode;
	}
	$this->set('default_aliquot_barcodes', $default_aliquot_barcodes);
	
?>
