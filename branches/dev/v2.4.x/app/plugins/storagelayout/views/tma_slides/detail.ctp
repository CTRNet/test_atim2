<?php
	
	// Set links and settings
	$structure_links = array();
	$settings = array();
	
	//Basic
	$structure_links = array(
		'bottom' => array(
			'edit' => '/storagelayout/tma_slides/edit/' . $atim_menu_variables['StorageMaster.id'] . '/' . $atim_menu_variables['TmaSlide.id'],
			'delete' => '/storagelayout/tma_slides/delete/' . $atim_menu_variables['StorageMaster.id'] . '/' . $atim_menu_variables['TmaSlide.id'],
			'list' => '/storagelayout/tma_slides/listAll/' . $atim_menu_variables['StorageMaster.id']
		)
	);		
	
	//Clean up based on form type 
	if($is_from_tree_view_or_layout == 1) {
		// Tree view
		unset($structure_links['bottom']['list']);
		$settings = array('header' => __('tma slide', true));
	
	} else if($is_from_tree_view_or_layout == 2) {
		// Storage Layout
		$structure_links = array();
		$structure_links['bottom']['access to all data'] = '/storagelayout/tma_slides/detail/'. $atim_menu_variables['StorageMaster.id'] . '/' . $atim_menu_variables['TmaSlide.id'];
		$settings = array('header' => __('tma slide', true));
		
	}
				
	$form_override = array();
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'settings' => $settings);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );		
?>