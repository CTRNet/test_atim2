<?php 
			
	if(!$initial_display){
		foreach($this->request->data as $tmp_key_block_storage_master_id => &$tmp_data_unit){
			$last_block_tma_section_id = '';
			foreach($tmp_data_unit as &$tmp_data) {
				if(isset($tmp_data['TmaSlide'])) {
					if(preg_match('/[0-9]+/', $tmp_data['TmaSlide']['qc_tf_cpcbn_section_id'])) {
						$last_block_tma_section_id = $tmp_data['TmaSlide']['qc_tf_cpcbn_section_id'];
					} else if($tmp_data['TmaSlide']['qc_tf_cpcbn_section_id'] == '+' && preg_match('/[0-9]+/', $last_block_tma_section_id)) {
						$last_block_tma_section_id++;
						$tmp_data['TmaSlide']['qc_tf_cpcbn_section_id'] = $last_block_tma_section_id;
					} else {
						$last_block_tma_section_id = '';
					}
				}
			}				
		}			
	}
	
?>