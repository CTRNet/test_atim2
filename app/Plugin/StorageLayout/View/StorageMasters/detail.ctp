<?php
	
	// 1 ** DISPLAY STORAGE FORM **
	
	// Set links and settings
	$structure_links = array();
	$settings = array();
	
	//Basic
	$structure_links['bottom']['edit'] = '/StorageLayout/StorageMasters/edit/' . $atim_menu_variables['StorageMaster.id'];
	if($is_tma) {
		// No children storage could be added to a TMA block
		// Add button to create slide
		$structure_links['bottom']['add tma slide'] = '/StorageLayout/TmaSlides/add/' . $atim_menu_variables['StorageMaster.id'];
	} else{
		$add_links = array();
		foreach ($storage_controls_list as $storage_control) {
			$add_links[__($storage_control['StorageControl']['storage_type'])] = '/StorageLayout/StorageMasters/add/' . $storage_control['StorageControl']['id'] . '/' . $atim_menu_variables['StorageMaster.id'];
		}
		ksort($add_links);
		$structure_links['bottom']['add to storage'] = (empty($add_links)? '/underdevelopment/': $add_links);					
	}
	if(!empty($parent_storage_id)){
		$structure_links['bottom']['see parent storage'] = '/StorageLayout/StorageMasters/detail/' . $parent_storage_id;
	}
	$structure_links['bottom']['delete'] = '/StorageLayout/StorageMasters/delete/' . $atim_menu_variables['StorageMaster.id'];

	//Clean up based on form type 
	if($is_from_tree_view_or_layout == 1) {
		// Display Detail From Tree view
		unset($structure_links['bottom']['see parent storage']);
		unset($structure_links['bottom']['search']);
		$settings = array('header' => __($is_tma?'TMA-blc':'storage'));
	
	} else if($is_from_tree_view_or_layout == 2) {
		// Display Detail From Storage Layout
		$structure_links = array();
		$structure_links['bottom']['access to all data'] = '/StorageLayout/StorageMasters/detail/'.$atim_menu_variables['StorageMaster.id'];
		$settings = array('header' => __($is_tma?'TMA-blc':'storage'));
	} else if($is_tma) {
		// Main TMA Display
		$settings = array('actions' => false);
	}
	
	$settings['no_sanitization']['StorageMaster'] = array('layout_description');

	// Set override
	$structure_override = array();
			
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'settings' => $settings);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
	if(!$is_from_tree_view_or_layout && $is_tma) {

		// 2 ** DISPLAY TMA SLIDES **	
		
		$final_atim_structure = array();
		$final_options = array(
				'links' => $structure_links,
				'settings' => array('header' => __('slides', null)),
				'extras' => array('end' => $this->Structures->ajaxIndex('/StorageLayout/TmaSlides/listAll/' . $atim_menu_variables['StorageMaster.id'].'/')));
		
		// CUSTOM CODE
		$hook_link = $this->Structures->hook();
		if( $hook_link ) {
			require($hook_link);
		}
		
		// BUILD FORM
		$this->Structures->build( $final_atim_structure, $final_options );	
	
	}

?>