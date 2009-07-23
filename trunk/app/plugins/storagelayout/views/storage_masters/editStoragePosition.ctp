<?php 
	$sidebars->header($lang);
	$sidebars->cols($ctrapp_sidebar, $lang);
	$summaries->build($ctrapp_summary, $lang); 
	$menus->tabs($ctrapp_menu, $lang); 
?>

<?php

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
		$form_extras,
		$form_override, 
		$form_extras); 
	
?>  
		
<?php echo $sidebars->footer($lang); ?>
