<?php

	// Set links
	$structure_links = array();
	
	// If a parent sample is defined then set the 'Show Parent' button
	$show_parent_link = '/underdevelopment/';
	if(!empty($parent_sample_data)) { $show_parent_link = '/inventorymanagement/sample_masters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $parent_sample_data['SampleMaster']['id']; }
	
	// Create array of derivative type that could be created from studied sample for the ADD button
	$add_derivatives = array();
	foreach($allowed_derivative_type as $sample_control) {
		$add_derivatives[$sample_control['SampleControl']['sample_type']] = '/inventorymanagement/sample_masters/add/' . $atim_menu_variables['Collection.id'] . '/' . $sample_control['SampleControl']['id'] . '/' . $atim_menu_variables['SampleMaster.id'];
	}		
	$add_derivatives = empty($add_derivatives)? '/underdevelopment/': $add_derivatives;
	
	// Create array of aliquot type that could be created for the studied sample for the ADD button 
	$add_aliquots = array();	
	foreach($allowed_aliquot_type as $aliquot_control) {
		$add_aliquots[$aliquot_control['AliquotControl']['aliquot_type']] = '/inventorymanagement/aliquot_masters/add/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $aliquot_control['AliquotControl']['id'];
	}		
	$add_aliquots = empty($add_aliquots)? '/underdevelopment/': $add_aliquots;
	
	$structure_links = array();
	if(!$is_product_tree_view ){
		$structure_links['bottom'] = array(
			'edit' => '/inventorymanagement/sample_masters/edit/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'], 
			'delete' => '/inventorymanagement/sample_masters/delete/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'], 
			'see parent sample' => $show_parent_link,
			'add derivative' => $add_derivatives,
			'add aliquot' => $add_aliquots
		);
	}
		
	if($is_tree_view_detail_form) {
		// Detail form displayed in collection content tree view
		// Add button to access all  sample
		$structure_links['bottom']['access to all data'] = '/inventorymanagement/sample_masters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'];
	} else {
		// General detail form display
		$search_type_links = array();
		$search_type_links['collection'] = '/inventorymanagement/collections/index/';
		$search_type_links['sample'] = '/inventorymanagement/sample_masters/index/';
		$search_type_links['aliquot'] = '/inventorymanagement/aliquot_masters/index/';
	
		$structure_links['bottom']['search'] = $search_type_links;
	}

	$structure_override = array();
	
	$structure_override['SampleMaster.sop_master_id'] = $arr_sample_sops;
	$structure_override['SampleMaster.parent_id'] = (empty($parent_sample_data))? '' : $parent_sample_data['SampleMaster']['sample_code'] . ' [' . __($parent_sample_data['SampleMaster']['sample_type'], TRUE) . ']';
	if(!empty($col_to_creation_spent_time)) { $structure_override['Generated.coll_to_creation_spent_time_msg'] = manageSpentTimeDataDisplay($col_to_creation_spent_time); }

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