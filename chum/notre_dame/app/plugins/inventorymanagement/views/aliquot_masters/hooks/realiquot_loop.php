<?php 
	
	if(isset($default_aliquot_labels[$parent['AliquotMaster']['sample_master_id']])) {
		$final_options_children['override']['AliquotMaster.aliquot_label'] = $default_aliquot_labels[$parent['AliquotMaster']['sample_master_id']];
	}
	
?>
