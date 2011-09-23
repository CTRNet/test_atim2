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
		if(empty($participant_id)){
			$bottom_links['participant'] = '/underdevelopment/';
		}else{
			$bottom_links['participant'] = array(
				'detail'		=> '/clinicalannotation/participants/profile/' . $participant_id,
				'collections'	=> array(
					'icon'	=> 'detail',
					'link'	=> '/clinicalannotation/product_masters/productsTreeView/' . $participant_id
					) 
					
			);
		}
		$bottom_links['add specimen'] = $add_links;
		$bottom_links['delete'] = '/inventorymanagement/collections/delete/' . $atim_menu_variables['Collection.id'];
		
		if(!empty($templates)){
			$bottom_links['template'] = array();
			foreach($templates as $template){
				$bottom_links['template'][$template['Template']['name']] = array(
					'icon' => 'template',
					'link' => '/inventorymanagement/collections/template/'.$atim_menu_variables['Collection.id'].'/'.$template['Template']['id']
				);
			}
		}
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