<?php 
	
	$structure_links = array(
		'top' => '/inventorymanagement/collections/edit/' . $atim_menu_variables['Collection.id'],
		'bottom' => array('cancel' => '/inventorymanagement/collections/detail/' . $atim_menu_variables['Collection.id'])
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links,'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
?>