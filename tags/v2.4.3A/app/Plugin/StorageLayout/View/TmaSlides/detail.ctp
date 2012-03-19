<?php
	
	// Set links and settings
	$structure_links = array();
	$settings = array();
	
	//Basic
	$structure_links = array(
		'bottom' => array(
			'edit' => '/StorageLayout/TmaSlides/edit/' . $atim_menu_variables['StorageMaster.id'] . '/' . $atim_menu_variables['TmaSlide.id'],
			'delete' => '/StorageLayout/TmaSlides/delete/' . $atim_menu_variables['StorageMaster.id'] . '/' . $atim_menu_variables['TmaSlide.id'],
			'list' => '/StorageLayout/TmaSlides/listAll/' . $atim_menu_variables['StorageMaster.id']
		)
	);		
	
	//Clean up based on form type 
	if($is_from_tree_view_or_layout == 1) {
		// Tree view
		unset($structure_links['bottom']['list']);
		$settings = array('header' => __('tma slide'));
	
	} else if($is_from_tree_view_or_layout == 2) {
		// Storage Layout
		$structure_links = array();
		$structure_links['bottom']['access to all data'] = '/StorageLayout/TmaSlides/detail/'. $atim_menu_variables['StorageMaster.id'] . '/' . $atim_menu_variables['TmaSlide.id'];
		$settings = array('header' => __('tma slide'));
		
	}
				
	$form_override = array();
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'settings' => $settings);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );		
?>