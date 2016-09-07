<?php 
	
	if(isset($default_aliquot_labels[$parent['AliquotMaster']['id']])) {
		$final_options_children['override']['AliquotMaster.aliquot_label'] = $default_aliquot_labels[$parent['AliquotMaster']['id']];
	}	
	
?>
