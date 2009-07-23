<?php 
	$sidebars->header( $lang );
	$sidebars->cols( $ctrapp_sidebar, $lang );
	$summaries->build( $ctrapp_summary, $lang );
	$menus->tabs( $ctrapp_menu, $lang ); 
?>
	
<?php 

	//----------------------------------------
	// 1- Set Model including generated data
	//----------------------------------------
	$arr_generated_data = array('Generated' => array());	
	if(isset($parent_coord_x_title)){
		$arr_generated_data['Generated']['parent_coord_x_title'] = $parent_coord_x_title;
	}
	if(isset($parent_coord_y_title)){
		$arr_generated_data['Generated']['parent_coord_y_title'] = $parent_coord_y_title;
	}
			
	$form_model = isset($this->params['data']) ? 
		array($this->params['data']) : 
		array(array_merge($data, $arr_generated_data));
	
	//-----------------------------------
	// 2- Display form to select position
	//-----------------------------------
	
	$form_type = 'edit';
	
	$form_field = $ctrapp_form_position;

	$form_link = array('edit' => '/storagelayout/storage_masters/editAliquotPosition/'.$source_page.'/');

	$form_lang = $lang;

	$form_override = array();
	if(isset($a_coord_x_liste)){
		$form_override['AliquotMaster/storage_coord_x'] = $a_coord_x_liste;
	}
	if(isset($a_coord_y_liste)){
		$form_override['AliquotMaster/storage_coord_y'] = $a_coord_y_liste;
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
		$form_pagination, 
		$form_override, 
		$form_extras);  

	//-----------------------------------
	// 3- Display return button
	//-----------------------------------
	
	$html_string = '';
	$html_string .= '<h5>';
	
	if(strcmp($source_page, 'AliquotDetail') == 0){
		// The user launch the aliquot position selection from 
		// aliquot detail form
				
		$html_string .=$html->link($translations->t('return', $lang, false),
			'/inventorymanagement/aliquot_masters/detailAliquotFromId/'.$aliquot_master_id.'/',
			array('class' => 'form detail'));
								 	
	} else {
		// (We suppose) The user launch the aliquot position selection from 
		// storage aliquots list form
		
		$html_string .=$html->link($translations->t('return', $lang, false),
			'/storagelayout/storage_masters/searchStorageAliquots/'.$aliquot_storage_master_id.'/',
			array('class' => 'form detail'));
			
	}
	
	$html_string .= 'Actions</h5>';
			
	echo($html_string);

?>  
		
<?php echo $sidebars->footer($lang); ?>
