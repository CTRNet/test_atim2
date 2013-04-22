<?php 

	if(isset($default_aliquot_data[$data['parent']['ViewSample']['sample_master_id']])) {
		$default_data = $default_aliquot_data[$data['parent']['ViewSample']['sample_master_id']];
		$final_options_children['override']['AliquotMaster.barcode'] = $default_data['barcode'];
	}
	
?>
