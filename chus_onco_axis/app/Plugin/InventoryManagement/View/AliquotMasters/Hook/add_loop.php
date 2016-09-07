<?php 

	$tmp_sample_master_id = $data['parent']['ViewSample']['sample_master_id'];
	if(isset($default_data[$tmp_sample_master_id])) {
		foreach($default_data[$tmp_sample_master_id] as $field => $default_value) {
			$final_options_children['override'][$field] = $default_value;
		}		
	}
	
?>
