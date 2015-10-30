<?php
	
	// --------------------------------------------------------------------------------
	// Set default aliquot label(s)
	// -------------------------------------------------------------------------------- 	
	if(isset($default_aliquot_labels)){	
		$label_counter = ($child_aliquot_ctrl['AliquotControl']['aliquot_type'] == 'block')? '' : 1;
		foreach($this->request->data as &$new_data_set){
			$sample_master_id = $new_data_set['parent']['AliquotMaster']['sample_master_id'];
			if(isset($default_aliquot_labels[$sample_master_id])) {
				$default_aliquot_label = $default_aliquot_labels[$sample_master_id];
				$new_data_set['children'][]['AliquotMaster']['aliquot_label'] = $default_aliquot_label.$label_counter;
			}
		}
	}
	
?>
