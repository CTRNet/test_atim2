<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/participants/edit/%%Consent.id%%',
		'bottom'=>array(
			'delete'=>'/clinicalannotation/participants/delete/%%Consent.id%%',
			'cancel'=>'/clinicalannotation/participants/profile/%%Consent.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>	
/*
	$sidebars->header( $lang );
	$sidebars->cols( $ctrapp_sidebar, $lang );
	$summaries->build( $ctrapp_summary, $lang ); 
	$menus->tabs( $ctrapp_menu, $lang ); 
?>
	
	<?php 
		$form_type = 'edit';
		$form_model = isset( $this->params['data'] ) ? array( $this->params['data'] ) : array( $data );
		$form_field = $ctrapp_form;
		$form_link = array( 'edit'=>'/clinicalannotation/consents/edit/'.$participant_id.'/', 'cancel'=>'/clinicalannotation/consents/detail/'.$participant_id.'/' );
		$form_lang = $lang;
		$form_pagination = NULL;
		$form_override = NULL;
		$form_extras = NULL;
		
		// ************ START CUSTOM CODE CHECK **************
		if (file_exists($custom_ctrapp_view_hook)) { 
			require($custom_ctrapp_view_hook);
		}
		// ************* END CUSTOM CODE CHECK ***************
		
		$forms->build( 
			$form_type, 
			$form_model, 
			$form_field, 
			$form_link, 
			$form_lang, 
			$form_pagination, 
			$form_override, 
			$form_extras );  
	?>
		
<?php echo $sidebars->footer($lang); ?>
*/