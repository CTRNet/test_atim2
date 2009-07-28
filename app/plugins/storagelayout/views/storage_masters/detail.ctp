<?php
	// If a parent storage object is defined then set the 'Show Parent' button
	$show_parent_link = '/underdevelopment/';
	if(isset($parent_id)) {
		$show_parent_link = '/storagelayout/storage_masters/detail/'.$parent_id;			
	}
	
	// If the selected storage object can be deleted then enable delete button
	$delete_link = '/underdevelopment/';
	if($bool_allow_deletion) {
		$delete_link = '/storagelayout/storage_masters/delete/'.$atim_menu_variables['StorageMaster.id'];
	}
	
	// Create array of valid, translated storage types for the ADD button
	$add_links = array();
	$translated_add_links = array();
	foreach ( $storage_controls as $storage_control ) {
		$add_links[$storage_control['StorageControl']['storage_type']] = '/storagelayout/storage_masters/add/'.$storage_control['StorageControl']['id'];
	}
	foreach($add_links as $key_id => $value_type){
		$translated_add_links[$key_id]= __($value_type, TRUE);
	}
	
	$structure_links = array(
		'bottom'=>array(
			'add' => $add_links,
			'show parent' => $show_parent_link,
			'search' => '/storagelayout/storage_masters/index/',
			'edit' => '/storagelayout/storage_masters/edit/'.$atim_menu_variables['StorageMaster.id'], 
			'delete' => $delete_link
		)
	);
		
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
	
	$structures->build( $atim_structure, array('links'=>$structure_links, 'override'=>$structure_override) );

	//-----------------------------------
	// Display form to display position
	//-----------------------------------
	
	if($bool_define_position) {
		echo('<br>');
		
		$position_links = array(
			'bottom'=>array(
				'edit position'=>'/storagelayout/storage_masters/editStoragePosition/'.$atim_menu_variables['StorageMaster.id']
			)
		);
		$position_override = array();
		if(isset($parent_coord_x_title)) {
			$position_override['Generated.parent_coord_x_title'] = __($parent_coord_x_title, TRUE);
		}
		if(isset($parent_coord_y_title)){
			$position_override['Generated.parent_coord_y_title'] = __($parent_coord_y_title, TRUE);
		}
		$position_override['Generated.position_into'] = $parent_code_from_id[$parent_id];
		
/*		TODO: See DETAIL function. Not sure if this generated list is needed for detail view.
		if(isset($a_coord_x_liste)){
			$position_override['StorageMaster.parent_storage_coord_x'] = $a_coord_x_liste;
		}
		if(isset($a_coord_y_liste)){
			$position_override['StorageMaster.parent_storage_coord_y'] = $a_coord_y_liste;
		}
*/		
		$structures->build( $atim_form_position, array('links'=>$position_links, 'override'=>$position_override));
	}
?>