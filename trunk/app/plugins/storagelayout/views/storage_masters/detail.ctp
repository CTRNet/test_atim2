<?php
	
	// DISPLAY STORAGE FORM
	
	// Set links
	$structure_links = array(
		'bottom'=>array(
			'edit' => '/storagelayout/storage_masters/edit/' . $atim_menu_variables['StorageMaster.id'], 
			'edit position'=> '/underdevelopment/',
			'delete' => '/storagelayout/storage_masters/delete/' . $atim_menu_variables['StorageMaster.id']
		)
	);	
	
	// If a parent storage object is defined then set the 'Show Parent' button
	if(!empty($parent_storage_id)) { 
		$show_parent_link = '/storagelayout/storage_masters/detail/' . $parent_storage_id; 
		$structure_links['bottom']['see parent storage'] = $show_parent_link;
	}
	
	
	// Create array of valid storage types for the ADD button
	if($is_tma) {
		// No children storage could be added to a TMA block
		// Add button to create slide
		$structure_links['bottom']['add tma slide'] = '/storagelayout/tma_slides/add/' . $atim_menu_variables['StorageMaster.id'];
	} else {
		$add_links = array();
		foreach ($storage_controls_list as $storage_control) {
			$add_links[__($storage_control['StorageControl']['storage_type'], true)] = '/storagelayout/storage_masters/add/' . $storage_control['StorageControl']['id'] . '/' . $atim_menu_variables['StorageMaster.id'];
		}
		ksort($add_links);
		$structure_links['bottom']['add to storage'] = (empty($add_links)? '/underdevelopment/': $add_links);					
	}
		
	if($is_tree_view_detail_form) {
		// Detail form displayed in children storage tree view
		// Add button to access all storage data
		$structure_links['bottom']['access to all data'] = array(
			'link'=> '/storagelayout/storage_masters/detail/' . $atim_menu_variables['StorageMaster.id'],
			'icon' => 'access_to_data');
	} else {
		// General detail form display
		$structure_links['bottom']['search'] = '/storagelayout/storage_masters/index/';
	}
		
	$structure_override = array();
	
	$structure_override['StorageMaster.parent_id'] = $parent_storage_for_display;
	$structure_override['Generated.path'] = $storage_path;
	
	if(!$bool_define_position) {
		// No sorage position within parent can be set	
		unset($structure_links['bottom']['edit position']);
		
		$final_atim_structure = $atim_structure; 
		$final_options = array('links' => $structure_links, 'override' => $structure_override);
		
		// CUSTOM CODE
		$hook_link = $structures->hook();
		if( $hook_link ) { require($hook_link); }
			
		// BUILD FORM
		$structures->build( $final_atim_structure, $final_options );
	
	} else {
		// A sorage position within parent can be set	
		$final_atim_structure = $atim_structure; 
		$final_options = array('settings' => array('actions' => false), 'override' => $structure_override);
		
		// CUSTOM CODE
		$hook_link = $structures->hook();
		if( $hook_link ) { require($hook_link); }
			
		// BUILD FORM
		$structures->build( $final_atim_structure, $final_options );
	
		// DISPLAY STORAGE POSITION FORM
		$structure_links['bottom']['edit position'] = '/storagelayout/storage_masters/editStoragePosition/' . $atim_menu_variables['StorageMaster.id']; 
		
		$position_structure_override = array();
			
		if(!empty($parent_coord_x_title)) { $position_structure_override['Generated.parent_coord_x_title'] = __($parent_coord_x_title, TRUE); }
		if(!empty($parent_coord_y_title)) { $position_structure_override['Generated.parent_coord_y_title'] = __($parent_coord_y_title, TRUE); }
		
		$final_atim_structure = $atim_structure_for_position; 
		$final_options = array('links' => $structure_links, 'override' => $position_structure_override);
		
		// CUSTOM CODE
		$hook_link = $structures->hook('position');
		if( $hook_link ) { require($hook_link); }
			
		// BUILD FORM
		$structures->build( $final_atim_structure, $final_options );
	}
?>