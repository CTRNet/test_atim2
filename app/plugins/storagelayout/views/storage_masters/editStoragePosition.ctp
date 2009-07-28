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
/*
	//----------------------------------------
	// 1- Set Model including generated data
	//----------------------------------------
		
	$arr_generated_data 
		= array('Generated' => array(
			'coord_x_title' => $coord_x_title,
			'coord_x_type' => $coord_x_type,
			'coord_y_title' => $coord_y_title,
			'coord_y_type' => $coord_y_type));
			
	if(isset($parent_coord_x_title)){
		$arr_generated_data['Generated']['parent_coord_x_title'] = $parent_coord_x_title;
	}
	if(isset($parent_coord_y_title)){
		$arr_generated_data['Generated']['parent_coord_y_title'] = $parent_coord_y_title;
	}
			
	$form_model = isset($this->params['data']) ? 
		array($this->params['data']) : 
		array(array_merge($data, $arr_generated_data));
		
	//----------------------------------------
	// 2- Display the detail about the storage
	//----------------------------------------
	
	$form_type = 'detail';
	
	$form_field = $ctrapp_form_storage;
	
	$form_link = array();
	$form_lang = $lang;
	
	$form_override = array();
	$form_override['Generated/coord_x_size'] 
		= (strcmp($coord_x_size, 'n/a')==0)? 
			$translations->t($coord_x_size, $lang, false):
			$coord_x_size;
	$form_override['Generated/coord_y_size'] 
		= (strcmp($coord_y_size, 'n/a')==0)? 
			$translations->t($coord_y_size, $lang, false):
			$coord_y_size;
	$form_override['StorageMaster/parent_id'] = $parent_code_from_id;
	$form_override['Generated/path'] = $storage_path;
	
    if(isset($arr_tma_sop_title_from_id)){
    	$form_override['StorageDetail/sop_master_id'] = $arr_tma_sop_title_from_id;
    }
		
	$form_pagination = NULL;
	$form_extras = NULL;
	
	// look for CUSTOM HOOKS, "format"
	if (file_exists($custom_ctrapp_view_hook)) { 
		require($custom_ctrapp_view_hook); 
	}
	
	$forms->build(
		$form_type, 
		$form_model, 
		$form_field, 
		$form_link, 
		$form_lang, 
		$form_pagination, 
		$form_override, 
		$form_extras);  
			
	//-----------------------------------
	// 3- Display form to select position
	//-----------------------------------
	
	$form_type = 'edit';
	
	$form_field = $ctrapp_form_position;
	
	$form_link = array(
		'edit' => '/storagelayout/storage_masters/editStoragePosition/', 
		'cancel' => '/storagelayout/storage_masters/detail/');

	$form_lang = $lang;

	$form_override = array();
	$form_override['Generated/position_into'] = $parent_code_from_id[$parent_id];
	if(isset($a_coord_x_liste)){
		$form_override['StorageMaster/parent_storage_coord_x'] = $a_coord_x_liste;
	}
	if(isset($a_coord_y_liste)){
		$form_override['StorageMaster/parent_storage_coord_y'] = $a_coord_y_liste;
	}
	
	$form_extras = NULL;	
	$form_pagination = NULL;
	
	$forms->build( 
		$form_type, 
		$form_model, 
		$form_field, 
		$form_link, 
		$form_lang, 
		$form_extras,
		$form_override, 
		$form_extras); 
*/
?>