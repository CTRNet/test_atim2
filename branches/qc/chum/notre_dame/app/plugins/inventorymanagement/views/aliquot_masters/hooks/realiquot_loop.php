<?php 

	if(isset($default_aliquot_barcodes[$parent['AliquotMaster']['id']])) {
		$final_options_children['override']['AliquotMaster.barcode'] = $default_aliquot_barcodes[$parent['AliquotMaster']['id']];
	}
	
?>
