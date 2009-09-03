<?php 
	
	$structure_links = array(
		'bottom'=>array(
			'edit' => '/inventorymanagement/collections/edit/' . $atim_menu_variables['Collection.id'], 
			'delete' => '/inventorymanagement/collections/delete/' . $atim_menu_variables['Collection.id']
		)
	);
	
	$structure_override = array();
	
	$bank_list = array();
	foreach($banks as $new_bank) {
		$bank_list[$new_bank['Bank']['id']] = $new_bank['Bank']['name'];
	}
	$structure_override['Collection.bank_id'] = $bank_list;
	
	$structure_override['Collection.sop_master_id'] = $arr_collection_sops;	
	
	$col_to_rec_spent_time_msg = '';
	if(!empty($col_to_rec_spent_time['message'])) { 
		$col_to_rec_spent_time_msg = __($col_to_rec_spent_time['message'], TRUE); 
	} else {
		$col_to_rec_spent_time_msg = (!empty($col_to_rec_spent_time['days']))? ($col_to_rec_spent_time['days'] . ' ' . __('days', TRUE) . ' ') : '';
		$col_to_rec_spent_time_msg .= (!empty($col_to_rec_spent_time['hours']))? ($col_to_rec_spent_time['hours'] . ' ' . __('hours', TRUE) . ' ') : '';
		$col_to_rec_spent_time_msg .= (!empty($col_to_rec_spent_time['minutes']))? ($col_to_rec_spent_time['minutes'] . ' ' . __('minutes', TRUE) . ' ') : '';
	} 	
	$structure_override['Generated.coll_to_rec_spent_time_msg'] = $col_to_rec_spent_time_msg;	

	$structures->build($atim_structure, array('links' => $structure_links, 'override' => $structure_override));
	
?>