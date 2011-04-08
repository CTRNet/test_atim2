<?php 
	
	$structure_links = array(
		'top' => '/inventorymanagement/aliquot_masters/addAliquotInternalUse/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'] . '/' ,
		'bottom' => array('cancel' => '/inventorymanagement/aliquot_masters/detail/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.initial_specimen_sample_id'].'/'.$atim_menu_variables['AliquotMaster.id'].'/'
		)
	);
	
	$structure_settings = array('header' => __('internal use', null));
			
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'type' => 'add', 'settings'=>$structure_settings);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );			
?>