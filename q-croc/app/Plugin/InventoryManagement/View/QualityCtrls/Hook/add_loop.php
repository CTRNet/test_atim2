<?php 
	
	$tmp_sample_master_id = isset($data['parent']['ViewSample']['sample_master_id'])? $data['parent']['ViewSample']['sample_master_id'] : $data['parent']['AliquotMaster']['sample_master_id'];
	if(isset($default_qc_data[$tmp_sample_master_id])) {
		foreach($default_qc_data[$tmp_sample_master_id] as $field => $value) $final_options_children['override'][$field] = $value;
	}
	