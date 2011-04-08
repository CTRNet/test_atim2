<?php 
	
	$structure_links = array(
		'top' => '/storagelayout/storage_masters/add/' . $atim_menu_variables['StorageControl.id'],
		'bottom' => array('cancel' => '/storagelayout/storage_masters/index/')
	);

	$structure_override = array();
	
	$structure_override['StorageMaster.storage_control_id'] = $storage_control_id;
	$structure_override['StorageMaster.layout_description'] = $layout_description;

	if(isset($predefined_parent_storage_selection_label)) $structure_override['FunctionManagement.recorded_storage_selection_label'] = $predefined_parent_storage_selection_label;
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>