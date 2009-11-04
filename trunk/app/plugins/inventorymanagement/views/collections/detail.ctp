<?php 

	$search_type_links = array();
	$search_type_links['collection'] = '/inventorymanagement/collections/index/';
	$search_type_links['sample'] = '/inventorymanagement/sample_masters/index/';
	$search_type_links['aliquot'] = '/inventorymanagement/aliquot_masters/index/';
		
	$structure_links = array();
		
	if($is_tree_view){
		$structure_links['bottom']['access to all data'] = '/inventorymanagement/collections/detail/' . $atim_menu_variables['Collection.id'] . '/';
	}else{
		$structure_links['bottom'] = array(
			'edit' => '/inventorymanagement/collections/edit/' . $atim_menu_variables['Collection.id'], 
			'delete' => '/inventorymanagement/collections/delete/' . $atim_menu_variables['Collection.id'],
			'search' => $search_type_links
		);
	}
	
	$structure_override = array();
	
	$bank_list = array();
	foreach($banks as $new_bank) {
		$bank_list[$new_bank['Bank']['id']] = $new_bank['Bank']['name'];
	}
	$structure_override['Collection.bank_id'] = $bank_list;
	
	$structure_override['Collection.sop_master_id'] = $arr_collection_sops;		
	$structure_override['Generated.coll_to_rec_spent_time_msg'] = manageSpentTimeDataDisplay($col_to_rec_spent_time);	

	$structures->build($atim_structure, array('links' => $structure_links, 'override' => $structure_override));
	
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */
	
	function manageSpentTimeDataDisplay($spent_time_data) {
		$spent_time_msg = '';
		if(!empty($spent_time_data)) {		
			if(!empty($spent_time_data['message'])) { 
				$spent_time_msg = __($spent_time_data['message'], TRUE); 
			} else {
				$spent_time_msg = translateDateValueAndUnit($spent_time_data, 'days') . translateDateValueAndUnit($spent_time_data, 'hours') . translateDateValueAndUnit($spent_time_data, 'minutes');
			} 	
		}
		return $spent_time_msg;
	}
	
	function translateDateValueAndUnit($spent_time_data, $time_unit) {
		if(array_key_exists($time_unit, $spent_time_data)) {
			return (((!empty($spent_time_data[$time_unit])) && ($spent_time_data[$time_unit] != '00'))? ($spent_time_data[$time_unit] . ' ' . __($time_unit, TRUE) . ' ') : '');
		} 
		return  '#err#';
	}
	
?>