<?php 
	
	if(isset($custom_override_data) && array_key_exists($data['parent']['AliquotMaster']['id'], $custom_override_data)) {
		$final_options_children['override'] = array_merge($final_options_children['override'], $custom_override_data[$data['parent']['AliquotMaster']['id']]);
	}
	
?>