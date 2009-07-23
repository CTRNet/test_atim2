<?php 
	$sidebars->header($lang);
	$sidebars->cols($ctrapp_sidebar, $lang);
	$summaries->build($ctrapp_summary, $lang); 
	$menus->tabs($ctrapp_menu, $lang); 
?>
	
<?php 

	$form_type = 'add';
	
	$form_model = isset($this->params['data']) ? 
		array($this->params['data']) : 
		array(array('StorageCoordinate'=> array())); 
				
	$form_field = $ctrapp_form;
	
	$form_link = array( 
		'add'=>'/storagelayout/storage_coordinates/add/', 
		'cancel'=>'/storagelayout/storage_coordinates/listAll/'.$storage_master_id.'/'); 

	$form_lang = $lang;

	$form_override = array();
	$form_override['StorageCoordinate/dimension'] = $dimension;
	
	$form_extras = $html->hiddenTag('StorageCoordinate/storage_master_id', $storage_master_id);
	$form_extras .= $html->hiddenTag('StorageCoordinate/dimension', $dimension);

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
	
?>

<?php echo $sidebars->footer($lang); ?>