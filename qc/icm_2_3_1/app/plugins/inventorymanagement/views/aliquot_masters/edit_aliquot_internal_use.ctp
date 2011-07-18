<?php 
	
	$structure_links = array(
		'top' => '/inventorymanagement/aliquot_masters/editAliquotInternalUse/' . $atim_menu_variables['AliquotMaster.id'] . '/%%AliquotInternalUse.id%%/',
		'bottom' => array('cancel' => '/inventorymanagement/aliquot_masters/detailAliquotInternalUse/' . $atim_menu_variables['AliquotMaster.id'] . '/%%AliquotInternalUse.id%%/'
		)
	);
	
	$structure_settings = array('header' => __('internal use', null));
			
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'type' => 'edit', 'settings'=>$structure_settings);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	

	
?>