<?php 
	
	if(isset($default_aliquot_data[$parent['AliquotMaster']['sample_master_id']])) {
		$tmp_sample_master_id = $parent['AliquotMaster']['sample_master_id'];
		$final_options_children['override']['AliquotMaster.aliquot_label'] = $default_aliquot_data[$tmp_sample_master_id]['aliquot_label'];
		if(isset($default_aliquot_data[$tmp_sample_master_id]['concentration_unit'])) {
			$final_options_children['override']['AliquotDetail.concentration_unit'] = $default_aliquot_data[$tmp_sample_master_id]['concentration_unit'];
		}
	}
	
	if(isset($default_realiquoted_by)) {
		$final_options_children['override']['Realiquoting.realiquoted_by'] = $default_realiquoted_by;
	}
	
?>
