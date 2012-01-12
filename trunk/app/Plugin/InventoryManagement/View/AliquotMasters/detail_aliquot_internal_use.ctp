<?php
	
	$structure_links = array(
		'top'=>NULL,
		'bottom'=>array(
			'edit'=>'/InventoryManagement/AliquotMasters/editAliquotInternalUse/'.$atim_menu_variables['AliquotMaster.id'].'/%%AliquotInternalUse.id%%/',
			'delete'=>'/InventoryManagement/AliquotMasters/deleteAliquotInternalUse/'.$atim_menu_variables['AliquotMaster.id'].'/%%AliquotInternalUse.id%%/'
		)
	);
	
	$structure_settings = array('header' => __('internal use', null));
			
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'type' => 'detail', 'settings'=>$structure_settings);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>