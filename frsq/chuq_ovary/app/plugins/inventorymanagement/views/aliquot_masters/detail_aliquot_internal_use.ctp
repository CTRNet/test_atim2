<?php
	
	$structure_links = array(
		'top'=>NULL,
		'bottom'=>array(
			'edit'=>'/inventorymanagement/aliquot_masters/editAliquotInternalUse/'.$atim_menu_variables['AliquotMaster.id'].'/%%AliquotInternalUse.id%%/',
			'delete'=>'/inventorymanagement/aliquot_masters/deleteAliquotInternalUse/'.$atim_menu_variables['AliquotMaster.id'].'/%%AliquotInternalUse.id%%/'
		)
	);
	
	$structure_settings = array('header' => __('internal use', null));
			
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'type' => 'detail', 'settings'=>$structure_settings);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>