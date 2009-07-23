<?php 
	$sidebars->header($lang);
	$sidebars->cols($ctrapp_sidebar, $lang);
	$summaries->build($ctrapp_summary, $lang); 
	$menus->tabs($ctrapp_menu, $lang); 
?>

<?php 
	$form_type = 'edit';
	$form_model = isset($this->params['data']) ? array($this->params['data']) : array($data);
	
	$form_field = $ctrapp_form;
	
	$form_link = array(
		'edit'=>'/storagelayout/tma_slides/edit/'.$std_tma_block_master_id.'/', 
		'cancel'=>'/storagelayout/tma_slides/detail/'.$std_tma_block_master_id.'/');
	
	$form_lang = $lang;
  	$form_pagination = NULL;

  	$form_override = array();
	$form_override['TmaSlide/sop_master_id'] = $arr_tma_slide_sop_title_from_id;

	$modified_arr_storage_list = array();
	foreach($arr_storage_list as $storage_id => $storage_data) {
		$modified_arr_storage_list[$storage_id]
			= $storage_data['code'].' (['.
			$storage_data['selection_label'].'] '.
			$translations->t($storage_data['storage_type'], $lang, false).')';
	}
	$form_override['TmaSlide/storage_master_id'] = $modified_arr_storage_list;	
	
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
		
?>
		
<?php echo $sidebars->footer($lang); ?>
