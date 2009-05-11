<?php
	$structure_links = array(
		'top'=>'/clinicalannotation/consents/detail/%%Participant.id%%,
		'bottom'=>array(
			'add'=>'/clinicalannotation/consents/add/%%Participant.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>
/*
	$sidebars->header( $lang );
	$sidebars->cols( $ctrapp_sidebar, $lang );
	$summaries->build( $ctrapp_summary, $lang ); 
	$menus->tabs( $ctrapp_menu, $lang ); 
?>
	
	<?php 
		$form_type = 'index';
		$form_model = $consents;
		$form_field = $ctrapp_form;
		$form_link = array( 'add'=>'/clinicalannotation/consents/add/'.$participant_id.'/', 'detail'=>'/clinicalannotation/consents/detail/'.$participant_id.'/' );
		$form_lang = $lang;
		$form_pagination = $paging;
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
