<?php

	// Set links
	$acces_to_storage_link = '/underdevelopment/';
	$remove_from_storage_link = '/underdevelopment/';
	
	if(!empty($aliquot_storage_data)) {
		$acces_to_storage_link = '/storagelayout/storage_masters/detail/' . $aliquot_storage_data['StorageMaster']['id'];
		$remove_from_storage_link = '/underdevelopment/';		
	}
	
	$structure_links = array();
	if(!$is_product_tree_view){
		$structure_links['bottom'] =array(
			'edit' => '/inventorymanagement/aliquot_masters/edit/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'], 
			'delete' => '/inventorymanagement/aliquot_masters/delete/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'], 
			'add to order' => '/underdevelopment/',
			'remove from storage' => '/inventorymanagement/aliquot_masters/removeAliquotFromStorage/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'],
			'plugin storagelayout access to storage' => $acces_to_storage_link
		);
	}
	
	if($is_tree_view_detail_form) {
		// Detail form displayed in collection content tree view and storage content tree view
		if(!$is_collection_tree_view) { $structure_links = array(); }
		// Add button to access all aliquot data
		$structure_links['bottom']['access to all data'] = '/inventorymanagement/aliquot_masters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'];
	} else {
		// General detail form display
		$search_type_links = array();
		$search_type_links['collection'] = '/inventorymanagement/collections/index/';
		$search_type_links['sample'] = '/inventorymanagement/sample_masters/index/';
		$search_type_links['aliquot'] = '/inventorymanagement/aliquot_masters/index/';
	
		$structure_links['bottom']['search'] = $search_type_links;
	}

	$structure_override = array();

	$structure_override['AliquotMaster.sop_master_id'] = $arr_aliquot_sops;		
		
	$studies_list = array();
	foreach($arr_studies as $new_study) {
		$studies_list[$new_study['StudySummary']['id']] = $new_study['StudySummary']['title'];
	}	
	$structure_override['AliquotMaster.study_summary_id'] = $studies_list;	

	$blocks_list = array();
	pr('to test block');
	foreach($arr_sample_blocks as $new_block) {
		// TODO test
	}	
	$structure_override['AliquotDetail.block_aliquot_master_id'] = $blocks_list;	

	$gel_matrices_list = array();
	pr('to test matrix');
	foreach($arr_sample_gel_matrices as $new_matrix) {
		// TODO test
	}	
	$structure_override['AliquotDetail.gel_matrix_aliquot_master_id'] = $gel_matrices_list;	

	if(isset($coll_to_stor_spent_time_msg)) { $structure_override['Generated.coll_to_stor_spent_time_msg'] = manageSpentTimeDataDisplay($coll_to_stor_spent_time_msg); }
	if(isset($rec_to_stor_spent_time_msg)) { $structure_override['Generated.rec_to_stor_spent_time_msg'] = manageSpentTimeDataDisplay($rec_to_stor_spent_time_msg); }
	if(isset($creat_to_stor_spent_time_msg)) { $structure_override['Generated.creat_to_stor_spent_time_msg'] = manageSpentTimeDataDisplay($creat_to_stor_spent_time_msg); }
	
	$structures->build($atim_structure, array('links'=>$structure_links, 'override' => $structure_override));
		
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