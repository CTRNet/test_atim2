<?php 
	
	$structure_links = array(
		'top' => '/inventorymanagement/sample_masters/add/'. $atim_menu_variables['Collection.id'] . '/' . $sample_control_data['SampleControl']['id'] . '/' . $parent_sample_master_id,
		'bottom' => array('cancel' => '/inventorymanagement/sample_masters/contentTreeView/'.$atim_menu_variables['Collection.id']
		)
	);
	
	$structure_override = array();

	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	echo($final_atim_structure['Structure']['alias']);
	$structures->build( $final_atim_structure, $final_options );		
?>