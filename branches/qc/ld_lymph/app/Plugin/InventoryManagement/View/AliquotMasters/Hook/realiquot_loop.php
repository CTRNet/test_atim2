<?php 
	
	if(isset($default_aliquot_data[$parent['AliquotMaster']['sample_master_id']])) {
		$tmp_sample_master_id = $parent['AliquotMaster']['sample_master_id'];
		$final_options_children['override']['AliquotMaster.barcode'] = $default_aliquot_data[$tmp_sample_master_id]['barcode'];
	}
	
	
?>
