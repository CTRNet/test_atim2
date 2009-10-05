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
	if(empty($add_derivatives)) {
		$add_derivatives = '/underdevelopment/';
	}
	
	// Create array of aliquot type that could be created for the studied sample for the ADD button 
	$add_aliquots = array();	
	foreach($allowed_aliquot_type as $aliquot_control) {
		$add_aliquots[$aliquot_control['AliquotControl']['aliquot_type']] = '/inventorymanagement/aliquot_masters/add/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $aliquot_control['AliquotControl']['id'];
	}		
	if(empty($add_aliquots)) {
		$add_aliquots = '/underdevelopment/';
	}	
	
	$structure_links = array(
		'bottom'=>array(
			'edit' => '/inventorymanagement/sample_masters/edit/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'], 
			'delete' => '/inventorymanagement/sample_masters/delete/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'], 
			'see parent sample' => $show_parent_link,
			'add derivative' => $add_derivatives,
			'add aliquot' => $add_aliquots
		)
	);
		
	if($is_tree_view_detail_form) {
		// Detail form displayed in collection content tree view
		// Add button to access all  sample
		$structure_links['bottom']['all sample data'] = '/inventorymanagement/sample_masters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'];
	} else {
		// General detail form display
		$search_type_links = array();
		$search_type_links['collection'] = '/inventorymanagement/collections/index/';
		$search_type_links['sample'] = '/inventorymanagement/sample_masters/index/';
		$search_type_links['aliquot'] = '/underdevelopment/';
	
		$structure_links['bottom']['search'] = $search_type_links;
	}

	$structure_override = array();
	
	$structure_override['SampleMaster.sop_master_id'] = $arr_sample_sops;
	$structure_override['SampleMaster.parent_id'] = (empty($parent_sample_data))? '' : $parent_sample_data['SampleMaster']['sample_code'] . ' [' . __($parent_sample_data['SampleMaster']['sample_type'], TRUE) . ']';
	
	if(!empty($col_to_creation_spent_time)) {
		$col_to_creation_spent_time_msg = '';
		if(!empty($col_to_creation_spent_time['message'])) { 
			$col_to_creation_spent_time_msg = __($col_to_creation_spent_time['message'], TRUE); 
		} else {
			$col_to_creation_spent_time_msg = (!empty($col_to_creation_spent_time['days']))? ($col_to_creation_spent_time['days'] . ' ' . __('days', TRUE) . ' ') : '';
			$col_to_creation_spent_time_msg .= (!empty($col_to_creation_spent_time['hours']))? ($col_to_creation_spent_time['hours'] . ' ' . __('hours', TRUE) . ' ') : '';
			$col_to_creation_spent_time_msg .= (!empty($col_to_creation_spent_time['minutes']))? ($col_to_creation_spent_time['minutes'] . ' ' . __('minutes', TRUE) . ' ') : '';
		} 	
		$structure_override['Generated.coll_to_creation_spent_time_msg'] = $col_to_creation_spent_time_msg;			
	}

	$structures->build( $atim_structure, array('links'=>$structure_links, 'override' => $structure_override));
	
?>