<?php
	$structure_links = array(
		'top'=>'/clinicalannotation/diagnoses/add/%%Participant.id/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/diagnoses/index/%%Participant.id/'
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
		$form_type = 'add';
		$form_model = isset( $this->params['data'] ) ? array( $this->params['data'] ) : array( array( 'Diagnosis'=>array() ) );
		$form_field = $ctrapp_form;
		$form_link = array( 'add'=>'/clinicalannotation/diagnoses/add/'.$participant_id.'/', 'cancel'=>'/clinicalannotation/diagnoses/listall/'.$participant_id.'/' );
		$form_lang = $lang;
		$form_pagination = NULL;
		$form_override = array();
		$form_extras = array();
		$form_extras['end'] = $html->hiddenTag( 'Diagnosis/participant_id', $participant_id );
		$form_extras['start'] = $moreForm->associated_primary_form( $lang, $dx_listall, array( 'Diagnosis', 'case_number' ), 0, true );
		
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