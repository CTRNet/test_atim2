<?php 

	$structure_links = array(
		'top' => '/storagelayout/tma_slides/edit/' . $atim_menu_variables['StorageMaster.id'] . '/' . $atim_menu_variables['TmaSlide.id'],
		'bottom' => array('cancel' => '/storagelayout/tma_slides/detail/' . $atim_menu_variables['StorageMaster.id'] . '/' . $atim_menu_variables['TmaSlide.id'])
	);

	$structure_override = array();
	
	$structure_override['TmaSlide.storage_master_id'] = $arr_preselected_storages_for_display;
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );		
?>
