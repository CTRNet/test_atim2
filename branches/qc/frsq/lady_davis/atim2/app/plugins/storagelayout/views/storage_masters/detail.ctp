<?php
	
	// DISPLAY STORAGE FORM
	
	// Set links and settings
	$structure_links = array();
	$settings = array();
	
	//Basic
	$structure_links['bottom']['new search'] = array('link' => '/storagelayout/storage_masters/search/', 'icon' => 'search');
	$structure_links['bottom']['edit'] = '/storagelayout/storage_masters/edit/' . $atim_menu_variables['StorageMaster.id'];
	if($is_tma) {
		// No children storage could be added to a TMA block
		// Add button to create slide
		$structure_links['bottom']['add tma slide'] = '/storagelayout/tma_slides/add/' . $atim_menu_variables['StorageMaster.id'];
	} else{
		$add_links = array();
		foreach ($storage_controls_list as $storage_control) {
			$add_links[__($storage_control['StorageControl']['storage_type'], true)] = '/storagelayout/storage_masters/add/' . $storage_control['StorageControl']['id'] . '/' . $atim_menu_variables['StorageMaster.id'];
		}
		ksort($add_links);
		$structure_links['bottom']['add to storage'] = (empty($add_links)? '/underdevelopment/': $add_links);					
	}
	if(!empty($parent_storage_id)){
		$structure_links['bottom']['see parent storage'] = '/storagelayout/storage_masters/detail/' . $parent_storage_id;
	}
	$structure_links['bottom']['delete'] = '/storagelayout/storage_masters/delete/' . $atim_menu_variables['StorageMaster.id'];

	//Clean up based on form type 
	if($is_from_tree_view_or_layout == 1) {
		// Tree view
		unset($structure_links['bottom']['see parent storage']);
		unset($structure_links['bottom']['search']);
		$settings = array('header' => __('storage', true));
	
	} else if($is_from_tree_view_or_layout == 2) {
		// Storage Layout
		$structure_links = array();
		$structure_links['bottom']['access to all data'] = '/storagelayout/storage_masters/detail/'.$atim_menu_variables['StorageMaster.id'];
		$settings = array('header' => __('storage', true));
	}

	// Set override
	$structure_override = array();
			
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'settings' => $settings);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>