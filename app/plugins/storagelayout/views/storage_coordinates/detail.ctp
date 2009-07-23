<?php 
	$sidebars->header($lang);
	$sidebars->cols($ctrapp_sidebar, $lang);
	$summaries->build($ctrapp_summary, $lang); 
	$menus->tabs($ctrapp_menu, $lang); 
?>
	
<?php 
	
	$form_type = 'detail';
	
	$form_model = isset( $this->params['data'] ) ? array( $this->params['data'] ) : array( $data );		
	$form_field = $ctrapp_form;
		
	$form_link = array();
	if($bool_allow_deletion){
		$form_link['delete'] = '/storagelayout/storage_coordinates/delete/'.$storage_master_id.'/';
	}
	
	$form_lang = $lang;
	
	$form_override = NULL;
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
	
?>  
		
<?php echo $sidebars->footer($lang); ?>
