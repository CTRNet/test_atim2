<?php
	
	// DISPLAY STORAGE FORM
	
	$structure_override = array();
	
	$structure_override['Generated.coord_x_title'] = __($coord_x_title, TRUE);
	$structure_override['Generated.coord_x_type'] = __($coord_x_type, TRUE);
	$structure_override['Generated.coord_x_size'] = (strcmp($coord_x_size, 'n/a')==0)? __($coord_x_size, TRUE): $coord_x_size;
	
	$structure_override['Generated.coord_y_title'] = __($coord_y_title, TRUE);
	$structure_override['Generated.coord_y_type'] = __($coord_y_type, TRUE);
	$structure_override['Generated.coord_y_size'] = (strcmp($coord_y_size, 'n/a')==0)? __($coord_y_size, TRUE): $coord_y_size;
	
	$structure_override['StorageMaster.parent_id'] = (empty($parent_storage_data))? '' : $parent_storage_data['StorageMaster']['short_label'] . ' [' . __($parent_storage_data['StorageMaster']['storage_type'], TRUE) . ']';

	$path_to_display = '';
	foreach($storage_path_data as $new_parent_storage_data) { $path_to_display .= $new_parent_storage_data['StorageMaster']['code'] . ' / '; }
	$structure_override['Generated.path'] = $path_to_display;
	
	if(isset($arr_tma_sops)){
		$form_override['StorageDetail/sop_master_id'] = $arr_tma_sops;
	}

	$structures->build($atim_structure, array('settings' => array('actions' => FALSE), 'override' => $structure_override) );

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
	
	$structures->build($atim_structure_to_set_position, array('type' => 'edit', 'links' => $position_structure_links, 'override' => $position_structure_override));
?>