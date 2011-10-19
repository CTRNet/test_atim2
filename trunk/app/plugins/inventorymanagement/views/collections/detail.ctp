<?php 

	$structure_links = array();
	$settings = array();
		
	if($is_from_tree_view){
		// Detail form displayed in tree view
		$settings = array('header' => __('collection', true));
		
	}else{
		$add_links = array();
		foreach ($specimen_sample_controls_list as $sample_control) {
			$add_links[__($sample_control['SampleControl']['sample_type'], true)] = '/inventorymanagement/sample_masters/add/' . $atim_menu_variables['Collection.id'] . '/' . $sample_control['SampleControl']['id'];
		}
		ksort($add_links);
		
		$bottom_links = array('edit' => '/inventorymanagement/collections/edit/' . $atim_menu_variables['Collection.id']);
		$bottom_links['copy for new collection'] = array('link' => '/inventorymanagement/collections/add/0/'.$atim_menu_variables['Collection.id'], 'icon' => 'copy');
		$bottom_links['add specimen'] = $add_links;
		$bottom_links['add from template'] = $templates;
		if(empty($participant_id)){
			$bottom_links['participant data'] = '/underdevelopment/';
		}else{
			$bottom_links['participant data'] = array(
				'profile'		=> array(
					'icon'	=> 'participant',
					'link'	=> '/clinicalannotation/participants/profile/' . $participant_id),
				'participant inventory'	=> array(
					'icon'	=> 'participant',
					'link'	=> '/clinicalannotation/product_masters/productsTreeView/' . $participant_id
					) 
			);
		}
				
		$bottom_links['delete'] = '/inventorymanagement/collections/delete/' . $atim_menu_variables['Collection.id'];
		
		$structure_links['bottom'] = array_merge(array('new search' => InventorymanagementAppController::$search_links), $bottom_links);
		
	}
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'settings' => $settings);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
	
?>