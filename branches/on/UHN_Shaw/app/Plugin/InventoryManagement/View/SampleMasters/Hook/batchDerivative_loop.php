<?php 
	
	if(isset($uhn_default_values) && isset($uhn_default_values[$parent['ViewSample']['sample_master_id']])) {
		foreach($uhn_default_values[$parent['ViewSample']['sample_master_id']] as $uhn_model => $uhn_default_field_values) {
			foreach($uhn_default_field_values as $uhn_field => $uhn_dfault_value) {
				$final_options_children['override'][$uhn_model.'.'.$uhn_field] = $uhn_dfault_value;
			}
		}
	}
?>
