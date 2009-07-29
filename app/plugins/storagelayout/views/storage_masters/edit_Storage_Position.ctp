<?php
	$structure_override = array();
	$structure_override['Generated.coord_x_title'] = __($coord_x_title, TRUE);
	$structure_override['Generated.coord_x_type'] = __($coord_x_type, TRUE);
	$structure_override['Generated.coord_y_title'] = __($coord_y_title, TRUE);
	$structure_override['Generated.coord_y_type'] = __($coord_y_type, TRUE);
	
	$structure_override['Generated.coord_x_size']
		= (strcmp($coord_x_size, 'n/a')==0)? 
			__($coord_x_size, TRUE):
			$coord_x_size;
	$structure_override['Generated.coord_y_size'] 
		= (strcmp($coord_y_size, 'n/a')==0)? 
			__($coord_y_size, TRUE):
			$coord_y_size;

	$structure_override['StorageMaster.parent_id'] = $parent_code_from_id;
	$structure_override['Generated.path'] = $storage_path;
	
	$structures->build( $atim_structure, array('override'=>$structure_override) );

	//-----------------------------------
	// Display form to display position
	//-----------------------------------
	
	echo('<br>');
		
	$position_links = array(
		'top'=>'/storagelayout/storage_masters/editStoragePosition/'.$atim_menu_variables['StorageMaster.id'],
		'bottom'=>array(
			'cancel' => '/storagelayout/storage_masters/detail/'.$atim_menu_variables['StorageMaster.id']
		)
	);
	$position_override = array();
/*	if(isset($parent_coord_x_title)) {
		$position_override['Generated.parent_coord_x_title'] = __($parent_coord_x_title, TRUE);
	}
	if(isset($parent_coord_y_title)) {
		$position_override['Generated.parent_coord_y_title'] = __($parent_coord_y_title, TRUE);
	}
	$position_override['Generated.position_into'] = $parent_code_from_id[$parent_id];
*/		
	if(isset($a_coord_x_list)) {
		$position_override['StorageMaster.parent_storage_coord_x'] = $a_coord_x_list;
	}
	if(isset($a_coord_y_list)) {
		$position_override['StorageMaster.parent_storage_coord_y'] = $a_coord_y_list;
	}
/*	if(isset($coord_x_value)) {
		$position_override['StorageMaster.parent_storage_coord_x'] = $coord_x_value;
	}
	if(isset($coord_y_value)) {
		$position_override['StorageMaster.parent_storage_coord_y'] = $coord_y_value;
	}
*/		
	$structure_type = 'edit';
	$structures->build( $atim_form_position, array('type'=>$structure_type, 'links'=>$position_links, 'override'=>$position_override));
?>