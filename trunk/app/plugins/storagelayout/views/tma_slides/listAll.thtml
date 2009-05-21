<?php 
	$sidebars->header($lang);
	$sidebars->cols($ctrapp_sidebar, $lang);
	$summaries->build($ctrapp_summary, $lang); 
	$menus->tabs($ctrapp_menu, $lang); 
?>
	
<?php 

	$form_type = 'index';

	$form_model = $tma_slide_list;
	$form_field = $ctrapp_form;
		
	$form_link = array(
		'detail' => '/storagelayout/tma_slides/detail/'.$std_tma_block_master_id.'/',
		'add' => '/storagelayout/tma_slides/add/'.$std_tma_block_master_id.'/');

	$form_lang = $lang;
	$form_pagination = $paging;

	$form_override = NULL;
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
