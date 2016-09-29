<?php 
	
	$tmp_parent_aliquot_master_id = $parent['AliquotMaster']['id'];
	if(isset($default_data[$tmp_parent_aliquot_master_id])) {
		foreach($default_data[$tmp_parent_aliquot_master_id] as $field => $default_value) {
			$final_options_children['override'][$field] = $default_value;
		}
	}
	
?>
