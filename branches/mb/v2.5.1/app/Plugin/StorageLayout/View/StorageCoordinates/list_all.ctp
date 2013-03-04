<?php 
	
	$structure_links = array(
		'index' => array('delete' => '/StorageLayout/StorageCoordinates/delete/' . $atim_menu_variables['StorageMaster.id'] . '/%%StorageCoordinate.id%%'),
		'bottom' => array('add' => '/StorageLayout/StorageCoordinates/add/' . $atim_menu_variables['StorageMaster.id'] . '/')
	);	
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'index', 'links' => $structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );		
?>