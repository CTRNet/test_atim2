<?php 

	if(isset($default_aliquot_labels[$data['parent']['ViewSample']['sample_master_id']])) {
		$final_options_children['override']['AliquotMaster.aliquot_label'] = $default_aliquot_labels[$data['parent']['ViewSample']['sample_master_id']];
	}
	if(isset($default_in_stocks[$data['parent']['ViewSample']['sample_master_id']])) {
		$final_options_children['override']['AliquotMaster.in_stock'] = $default_in_stocks[$data['parent']['ViewSample']['sample_master_id']];
	}
	
?>
