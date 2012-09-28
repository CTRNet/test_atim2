<?php 
	
	$tmp_sample_master_id = $data['parent']['ViewSample']['sample_master_id'];
	if(isset($default_aliquot_data[$tmp_sample_master_id])) {
		foreach($default_aliquot_data[$tmp_sample_master_id] as $field => $value) $final_options_children['override'][$field] = $value;
	}
	