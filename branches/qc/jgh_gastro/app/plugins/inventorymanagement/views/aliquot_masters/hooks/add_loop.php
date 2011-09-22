<?php 

	if(isset($default_aliquot_barcodes[$data['parent']['ViewSample']['sample_master_id']])) {
		$final_options_children['override']['AliquotMaster.barcode'] = $default_aliquot_barcodes[$data['parent']['ViewSample']['sample_master_id']];
	}
	
?>