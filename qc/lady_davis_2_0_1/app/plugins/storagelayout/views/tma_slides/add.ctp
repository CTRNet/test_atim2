<?php 
	
	$structure_links = array(
		'top' => '/storagelayout/tma_slides/add/' . $atim_menu_variables['StorageMaster.id'],
		'bottom' => array('cancel' => '/storagelayout/tma_slides/listAll/' . $atim_menu_variables['StorageMaster.id'])
	);

	$structure_override = array();
		
	$structure_override['TmaSlide.sop_master_id'] = $arr_tma_slide_sops; 
	$structure_override['TmaSlide.storage_master_id'] = $matching_storage_list;
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );			
?>