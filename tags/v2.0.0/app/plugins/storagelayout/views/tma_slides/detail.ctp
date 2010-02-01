<?php
	
	// Set links
	$structure_links = array();
	
	$structure_links = array(
		'bottom' => array(
			'edit' => '/storagelayout/tma_slides/edit/' . $atim_menu_variables['StorageMaster.id'] . '/' . $atim_menu_variables['TmaSlide.id'],
			'delete' => '/storagelayout/tma_slides/delete/' . $atim_menu_variables['StorageMaster.id'] . '/' . $atim_menu_variables['TmaSlide.id']
		)
	);	
	
	if($is_tree_view_detail_form) {
		// Detail form displayed in children storage tree view
		// Add button to access all TMA slide data
		$structure_links['bottom']['access to all data'] = '/storagelayout/tma_slides/detail/' . $atim_menu_variables['StorageMaster.id'] . '/' . $atim_menu_variables['TmaSlide.id'];		
	} else {
		// General detail form display
		$structure_links['bottom']['list'] = '/storagelayout/tma_slides/listAll/' . $atim_menu_variables['StorageMaster.id'];
	}
				
	$form_override = array();
	
	$sops_list = array();
	foreach($arr_tma_slide_sops as $sop_masters) { $sops_list[$sop_masters['SopMaster']['id']] = $sop_masters['SopMaster']['code']; }
	$structure_override['TmaSlide.sop_master_id'] = $sops_list; 
			
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );		
?>