<?php 
	
	if(isset($default_aliquot_data[$parent['AliquotMaster']['sample_master_id']])) {
		$tmp_sample_master_id = $parent['AliquotMaster']['sample_master_id'];
		$final_options_children['override']['AliquotMaster.aliquot_label'] = $default_aliquot_data[$tmp_sample_master_id]['aliquot_label'];
		if(isset($default_aliquot_data[$tmp_sample_master_id]['block_type'])) {
			$final_options_children['override']['AliquotDetail.block_type'] = $default_aliquot_data[$tmp_sample_master_id]['block_type'];
		}
	}
	
?>
