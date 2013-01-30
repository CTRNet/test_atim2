<?php
	
	// DISPLAY STORAGE FORM
	
	$structure_override = array();
	
	$structure_override['Generated.coord_x_title'] = __($coord_x_title, TRUE);
	$structure_override['Generated.coord_x_type'] = __($coord_x_type, TRUE);
	$structure_override['Generated.coord_x_size'] = (strcmp($coord_x_size, 'n/a')==0)? __($coord_x_size, TRUE): $coord_x_size;
	
	$structure_override['Generated.coord_y_title'] = __($coord_y_title, TRUE);
	$structure_override['Generated.coord_y_type'] = __($coord_y_type, TRUE);
	$structure_override['Generated.coord_y_size'] = (strcmp($coord_y_size, 'n/a')==0)? __($coord_y_size, TRUE): $coord_y_size;
	
	$structure_override['StorageMaster.parent_id'] = $parent_storage_for_display;
	$structure_override['Generated.path'] = $storage_path;
	if(isset($arr_tma_sops)){ $structure_override['StorageDetail.sop_master_id'] = $arr_tma_sops; }

	$final_atim_structure = $atim_structure; 
	$final_options = array('settings' => array('actions' => FALSE), 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
	// DISPLAY STORAGE POSITION FORM
	
	$position_structure_links = array(
		'top' => '/storagelayout/storage_masters/editStoragePosition/' . $atim_menu_variables['StorageMaster.id'],
		'bottom' => array('cancel' => '/storagelayout/storage_masters/detail/' . $atim_menu_variables['StorageMaster.id']
		)
	);
	
	$position_structure_override = array();
	$position_structure_override['Generated.parent_coord_x_title'] = $parent_storage_data['StorageControl']['coord_x_title'];
	$position_structure_override['StorageMaster.parent_storage_coord_x'] = $a_coord_x_list;
	$position_structure_override['Generated.parent_coord_y_title'] = $parent_storage_data['StorageControl']['coord_y_title'];
	$position_structure_override['StorageMaster.parent_storage_coord_y'] = $a_coord_y_list;
	
	$final_atim_structure = $atim_structure_to_set_position; 
	$final_options = array('type' => 'edit', 'links' => $position_structure_links, 'override' => $position_structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook('position');
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
		
?>