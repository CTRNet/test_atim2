<?php

	// Set links
	$structure_links = array();
	
	// If a parent sample is defined then set the 'Show Parent' button
	$show_parent_link = null;
	if(!empty($parent_sample_master_id)) { $show_parent_link = '/inventorymanagement/sample_masters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $parent_sample_master_id; }
	
	// Create array of derivative type that could be created from studied sample for the ADD button
	$add_derivatives = array();
	foreach($allowed_derivative_type as $sample_control) {
		$add_derivatives[__($sample_control['SampleControl']['sample_type'],true)] = '/inventorymanagement/sample_masters/add/' . $atim_menu_variables['Collection.id'] . '/' . $sample_control['SampleControl']['id'] . '/' . $atim_menu_variables['SampleMaster.id'];
	}
	ksort($add_derivatives);
	
	// Create array of aliquot type that could be created for the studied sample for the ADD button 
	$add_aliquots = array();	
	foreach($allowed_aliquot_type as $aliquot_control) {
		$add_aliquots[__($aliquot_control['AliquotControl']['aliquot_type'],true)] = '/inventorymanagement/aliquot_masters/add/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $aliquot_control['AliquotControl']['id'];
	}
	ksort($add_aliquots);
	
	$structure_links = array();
	if($is_inventory_plugin_form){
		$structure_links['bottom'] = array(
			'edit' => '/inventorymanagement/sample_masters/edit/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'], 
			'add derivative' => $add_derivatives,
			'add aliquot' => $add_aliquots,
			'see parent sample' => $show_parent_link,
			'delete' => '/inventorymanagement/sample_masters/delete/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id']
		);
	}
	
	// Clean up structure link
	if(empty($structure_links['bottom']['add derivative'])) unset($structure_links['bottom']['add derivative']);
	if(empty($structure_links['bottom']['add aliquot'])) unset($structure_links['bottom']['add aliquot']);
	if(empty($structure_links['bottom']['see parent sample'])) unset($structure_links['bottom']['see parent sample']);
			
	if($is_tree_view_detail_form) {
		// Detail form displayed in tree view: Add button to access all sample data
		$structure_links['bottom']['access to all data'] = array(
			'link'=> '/inventorymanagement/sample_masters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'],
			'icon' => 'access_to_data');
	} else {
		// General detail form display
		$search_type_links = array();
		$search_type_links['collections'] = array('link'=> '/inventorymanagement/collections/index/', 'icon' => 'search');
		$search_type_links['samples'] = array('link'=> '/inventorymanagement/sample_masters/index/', 'icon' => 'search');
		$search_type_links['aliquots'] = array('link'=> '/inventorymanagement/aliquot_masters/index/', 'icon' => 'search');
	
		$structure_links['bottom']['new search'] = $search_type_links;
	}

	// Set override
	$structure_override = array();
	
	// BUILD FORM

	if(!isset($aliquots_listall_structure)) {

		// DISPLAY ONLY SAMPLE DETAIL FORM
		
		// 1- SAMPLE DETAIL	
		
		$final_atim_structure = $atim_structure; 
		$final_options = array('override' => $structure_override, 'links' => $structure_links, 'data' => $sample_master_data);
		
		// CUSTOM CODE
		$hook_link = $structures->hook();
		if( $hook_link ) { require($hook_link); }
			
		// BUILD FORM
		$structures->build( $final_atim_structure, $final_options );
		
	} else { 
		
		// DISPLAY BOTH SAMPLE DETAIL FORM AND SAMPLE ALIQUOTS LIST
		
		// 1- SAMPLE DETAIL	
		
		$final_atim_structure = $atim_structure; 
		$final_options = array('override' => $structure_override, 'settings' => array('actions' => false), 'data' => $sample_master_data);
		
		// CUSTOM CODE
		$hook_link = $structures->hook();
		if( $hook_link ) { require($hook_link); }
			
		// BUILD FORM
		$structures->build( $final_atim_structure, $final_options );

		// 2- ALIQUOTS LIST
		
		$structure_links['index']['detail'] = '/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
		
		$structure_override = array();
		
		$final_atim_structure = $aliquots_listall_structure; 
		$final_options = array('type' => 'index', 'links' => $structure_links, 'override' => $structure_override, 'data' => $aliquots_data, 'settings' => array('header' => __('aliquots', null), 'separator' => true));
		
		// CUSTOM CODE
		$hook_link = $structures->hook('aliquots');
		if( $hook_link ) { require($hook_link); }
			
		// BUILD FORM
		$structures->build( $final_atim_structure, $final_options );	
		
	}
	
?>