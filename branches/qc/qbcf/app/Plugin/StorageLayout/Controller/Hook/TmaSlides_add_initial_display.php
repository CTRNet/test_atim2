<?php 
	
	foreach($this->request->data as &$tmp_new_data_set) {
		$tmp_max_res = $this->TmaSlide->find('first', array('conditions' => array('TmaSlide.tma_block_storage_master_id' => $tmp_new_data_set['parent']['Block']['id']), 'fields' => array('MAX(TmaSlide.qbcf_section_id) AS last_id')));
		$tmp_new_data_set['children'][0]['TmaSlide']['qbcf_section_id'] = empty($tmp_max_res)? '1' : ($tmp_max_res[0]['last_id'] + 1);
	}

?>
