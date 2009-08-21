<?php
	
	// DISPLAY STORAGE FORM
	$structure_links = array();
	if($is_tree_view_detail_form) {
		// Detail displayed in children storage tree view: Just display details button to access storage
		$structure_links = array('bottom'=>array('detail' => '/storagelayout/storage_masters/detail/' . $atim_menu_variables['StorageMaster.id']));		

	} else {
		// If a parent storage object is defined then set the 'Show Parent' button
		$show_parent_link = '/underdevelopment/';
		if(!empty($parent_storage_data)) {
			$show_parent_link = '/storagelayout/storage_masters/detail/' . $parent_storage_data['StorageMaster']['id'];			
		}
		
		// Create array of valid storage types for the ADD button
		$add_links = array();
		if($is_tma) {
			// No children storage could be added to a TMA block
			$add_links = '/underdevelopment/';
		} else {
			foreach ( $storage_controls_list as $storage_control ) {
				$add_links[$storage_control['StorageControl']['storage_type']] = '/storagelayout/storage_masters/add/' . $storage_control['StorageControl']['id'] . '/' . $atim_menu_variables['StorageMaster.id'];
			}		
		}
		
		$structure_links = array(
			'bottom'=>array(
				'edit' => '/storagelayout/storage_masters/edit/' . $atim_menu_variables['StorageMaster.id'], 
				'edit position'=> '/underdevelopment/',
				'add to selected' => $add_links,
				'delete' => '/storagelayout/storage_masters/delete/' . $atim_menu_variables['StorageMaster.id'],
				'show parent' => $show_parent_link,
				'search' => '/storagelayout/storage_masters/index/'
			)
		);
	}
		
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

	if(!$bool_define_position) {
		// No sorage position within parent exists	
		$structures->build($atim_structure, array('links' => $structure_links, 'override' => $structure_override) );
	
	} else {
		// A sorage position within parent can exist	
		$structures->build($atim_structure, array('settings' => array('actions' => FALSE), 'override' => $structure_override) );

		// DISPLAY STORAGE POSITION FORM
		if(!$is_tree_view_detail_form) {		
			$structure_links['bottom']['edit position'] = '/storagelayout/storage_masters/editStoragePosition/' . $atim_menu_variables['StorageMaster.id'];
		}
		
		$position_structure_override = array();
			
		if(!empty($parent_coord_x_title)) { $position_structure_override['Generated.parent_coord_x_title'] = __($parent_coord_x_title, TRUE); }
		if(!empty($parent_coord_y_title)) { $position_structure_override['Generated.parent_coord_y_title'] = __($parent_coord_y_title, TRUE); }
		
		$structures->build($atim_structure_for_position, array('links' => $structure_links, 'override' => $position_structure_override));
		
	}
	
?>