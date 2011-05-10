<?php 
	
	$structure_links = array(
		'top' => '/storagelayout/storage_coordinates/add/' . $atim_menu_variables['StorageMaster.id'],
		'bottom' => array('cancel' => '/storagelayout/storage_coordinates/listall/' . $atim_menu_variables['StorageMaster.id'])
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
?>