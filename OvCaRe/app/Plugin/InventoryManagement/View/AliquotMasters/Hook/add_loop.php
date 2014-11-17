<?php 

	if(isset($default_aliquot_data[$data['parent']['ViewSample']['sample_master_id']])) {
		foreach($default_aliquot_data[$data['parent']['ViewSample']['sample_master_id']] as $model_and_field => $field_value) $final_options_children['override'][$model_and_field] = $field_value;
	}
	
?>
