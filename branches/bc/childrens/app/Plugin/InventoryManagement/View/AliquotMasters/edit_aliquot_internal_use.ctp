<?php 
	
	$structure_links = array(
		'top' => '/InventoryManagement/AliquotMasters/editAliquotInternalUse/' . $atim_menu_variables['AliquotMaster.id'] . '/'.$aliquot_use_id.'/',
		'bottom' => array('cancel' => '/InventoryManagement/AliquotMasters/detailAliquotInternalUse/' . $atim_menu_variables['AliquotMaster.id'] . '/'.$aliquot_use_id.'/'
		)
	);
	
	$structure_settings = array('header' => __('aliquot use/event', null));
			
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'type' => 'edit', 'settings'=>$structure_settings);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	

	
?>