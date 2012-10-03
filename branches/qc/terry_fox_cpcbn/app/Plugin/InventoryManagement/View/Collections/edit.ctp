<?php 
	
	$structure_links = array(
		'top' => '/InventoryManagement/Collections/edit/' . $atim_menu_variables['Collection.id'],
		'bottom' => array('cancel' => '/InventoryManagement/Collections/detail/' . $atim_menu_variables['Collection.id'])
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links,'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	
?>