<?php 
	
	$structure_links = array(
		'index' => array('delete' => '/storagelayout/storage_coordinates/delete/' . $atim_menu_variables['StorageMaster.id'] . '/%%StorageCoordinate.id%%'),
		'bottom' => array('add' => '/storagelayout/storage_coordinates/add/' . $atim_menu_variables['StorageMaster.id'] . '/')
	);	
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'index', 'links' => $structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );		
?>