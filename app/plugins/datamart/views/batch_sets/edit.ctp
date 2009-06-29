<?php 
	$sidebars->header( $lang );
	$sidebars->cols( $ctrapp_sidebar, $lang );
	$summaries->build( $ctrapp_summary, $lang ); 
	$menus->tabs( $ctrapp_menu, $lang ); 
?>
	
	<?php 
		$form_type = 'edit';
		$form_model = isset( $this->params['data'] ) ? array( $this->params['data'] ) : array( $data );
		$form_field = $ctrapp_form;
		$form_link = array( 'edit'=>'/datamart/batch_sets/edit/', 'cancel'=>'/datamart/batch_sets/listall/' );
		$form_lang = $lang;
		
		$forms->build( $form_type, $form_model, $form_field, $form_link, $form_lang ); 
	?>
		
<?php echo $sidebars->footer($lang); ?>