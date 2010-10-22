<?php 
	
	$structure_links = array(
		'top' => '/storagelayout/storage_masters/add/' . $atim_menu_variables['StorageControl.id'],
		'bottom' => array('cancel' => '/storagelayout/storage_masters/index/')
	);

	$structure_override = array();
	if(isset($predefined_parent_storage_list)) $structure_override['StorageMaster.parent_id'] = $predefined_parent_storage_list;
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>