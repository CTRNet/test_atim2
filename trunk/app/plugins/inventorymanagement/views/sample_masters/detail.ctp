<?php

	// Set links
	$structure_links = array();
	
	// If a parent sample is defined then set the 'Show Parent' button
	$show_parent_link = '/underdevelopment/';
	if(!empty($parent_sample_data)) { $show_parent_link = '/inventorymanagement/sample_masters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $parent_sample_data['SampleMaster']['id']; }
	
	// Create array of derivative type that could be created from studied sample for the ADD button
	$add_links = array();
	foreach($allowed_derivative_type as $sample_control) {
		$add_links[$sample_control['SampleControl']['sample_type']] = '/inventorymanagement/sample_masters/add/' . '.....' . $sample_control['SampleControl']['id'];
	}		
	if(empty($add_links)) {
		$add_links = '/underdevelopment/';
	}
	
	$structure_links = array(
		'bottom'=>array(
			'edit' => '/inventorymanagement/sample_masters/edit/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'], 
			'delete' => '/inventorymanagement/sample_masters/delete/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'], 
			'see parent sample' => $show_parent_link,
			'create derivative' => $add_links
		)
	);
		
	if($is_tree_view_detail_form) {
		// Detail form displayed in collection content tree view
		// Add button to access all  sample
		$structure_links['bottom']['all sample data'] = '/inventorymanagement/sample_masters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'];
	} else {
		// General detail form display
		$structure_links['bottom']['search'] = '/inventorymanagement/sample_masters/index/';
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