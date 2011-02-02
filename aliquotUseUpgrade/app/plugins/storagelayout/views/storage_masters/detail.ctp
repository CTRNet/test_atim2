<?php
	
	// DISPLAY STORAGE FORM
	
	// Set links
	$structure_links = array();
	$settings = array();
	
	if($is_tree_view_detail_form < 2){
		$structure_links = array('bottom' => array(
			'edit' => '/storagelayout/storage_masters/edit/' . $atim_menu_variables['StorageMaster.id'],
			'delete' => '/storagelayout/storage_masters/delete/' . $atim_menu_variables['StorageMaster.id'])
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
		} else{
			$add_links = array();
			foreach ($storage_controls_list as $storage_control) {
				$add_links[__($storage_control['StorageControl']['storage_type'], true)] = '/storagelayout/storage_masters/add/' . $storage_control['StorageControl']['id'] . '/' . $atim_menu_variables['StorageMaster.id'];
			}
			ksort($add_links);
			$structure_links['bottom']['add to storage'] = (empty($add_links)? '/underdevelopment/': $add_links);					
		}
		// General detail form display
		$structure_links['bottom']['search'] = '/storagelayout/storage_masters/index/';
	}
	
	if($is_tree_view_detail_form > 0){
		// Detail form displayed in children storage tree view
		// Add button to access all storage data
		$structure_links['bottom']['access to all data'] = array(
			'link'=> '/storagelayout/storage_masters/detail/' . $atim_menu_variables['StorageMaster.id'],
			'icon' => 'access_to_data');
		$settings = array('header' => __('storage', true));
	}
		
	$structure_override = array();
			
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'settings' => $settings);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>