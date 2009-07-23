<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/storagelayout/storage_masters/edit/'.$atim_menu_variables['StorageMaster.id'], 
			'delete'=>'/storagelayout/storage_masters/delete/'.$atim_menu_variables['StorageMaster.id'], 
			'search'=>'/storagelayout/storage_masters/index/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
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
	
	$form_field = $ctrapp_form;
	
	$form_link = array();
	$form_link['edit'] = '/storagelayout/storage_masters/edit/';
	if($bool_allow_deletion){
		$form_link['delete'] = '/storagelayout/storage_masters/delete/';
	}
	if(isset($parent_id)){
		// A parent exists and can be displayed
		$form_link['parent storage'] = '/storagelayout/storage_masters/detail/'.$parent_id.'/';			
	}
	$form_link['list'] = '/storagelayout/storage_masters/search/';	
	
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
	// 2- Display form to display position
	//-----------------------------------
	
	if($bool_define_position){
	
		echo('<br>');
	
		$form_type = 'detail';
		
		$form_field = $ctrapp_form_position;
		
		$form_link = array('edit'=>'/storagelayout/storage_masters/editStoragePosition/');
		
		$form_lang = $lang;
		
		$form_override = array();
		$form_override['Generated/position_into'] = $parent_code_from_id[$parent_id];
		if(isset($a_coord_x_liste)){
			$form_override['StorageMaster/parent_storage_coord_x'] = $a_coord_x_liste;
		}
		if(isset($a_coord_y_liste)){
			$form_override['StorageMaster/parent_storage_coord_y'] = $a_coord_y_liste;
		}
		
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
			NULL, 
			$form_override); 
	}

	//-----------------------------------
	// 3- Display Add button including
	// the storage types selection drop 
	// down list
	//-----------------------------------
		
	// Translate values
	$translated_storage_types = array();
	foreach($untranslated_storage_types as $key_id => $value_type){
		$translated_storage_types[$key_id]= $translations->t($value_type, $lang, false);
	}

	//  Build form to select new storage type to create
	if (!empty($translated_storage_types)){
		$html_string = '';
		
		$html_string .= 
			$html->formTag('/storagelayout/storage_masters/add/', 'post', array('id'=>'expanded_add'));
		
		$html_string .= '<fieldset>
							<input type="hidden" name="specific_parent_storage_id" value="'.$storage_master_id.'">
							<select name="storage_control_id">\n';

		foreach ($translated_storage_types as $key => $value) {
			$html_string .='<option value="'.$key.'">'.$value.'</option>\n';
		}

		$html_string .= '</select><input type="submit" class="submit add" value="'.$translations->t('add to storage', $lang, false).'
	" /></fieldset></form>';

		echo ($html_string);

	}
*/
?>
