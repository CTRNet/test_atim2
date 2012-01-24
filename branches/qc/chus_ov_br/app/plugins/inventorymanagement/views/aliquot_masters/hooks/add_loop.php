<?php 
	
	if(isset($default_aliquot_data[$data['parent']['ViewSample']['sample_master_id']])) {
		$tmp_sample_master_id = $data['parent']['ViewSample']['sample_master_id'];
		$final_options_children['override']['AliquotMaster.aliquot_label'] = $default_aliquot_data[$tmp_sample_master_id]['aliquot_label'];
		if(isset($default_aliquot_data[$tmp_sample_master_id]['concentration_unit'])) {
			$final_options_children['override']['AliquotDetail.concentration_unit'] = $default_aliquot_data[$tmp_sample_master_id]['concentration_unit'];
		}
	}
	

?>
