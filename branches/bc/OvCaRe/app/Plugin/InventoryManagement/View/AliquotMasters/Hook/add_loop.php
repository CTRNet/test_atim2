<?php 

	if(isset($default_aliquot_data[$data['parent']['ViewSample']['sample_master_id']])) {
		$default_data = $default_aliquot_data[$data['parent']['ViewSample']['sample_master_id']];
		$final_options_children['override']['AliquotMaster.aliquot_label'] = $default_data['aliquot_label'];
		$final_options_children['override']['AliquotMaster.ovcare_clinical_aliquot'] = 'no';
		if(isset($default_data['block_type'])) $final_options_children['override']['AliquotDetail.block_type'] = $default_data['block_type'];
	}
	
?>
