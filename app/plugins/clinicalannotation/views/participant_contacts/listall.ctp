<?
	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/participant_contacts/detail/%%Participant.id%%/%%ParticipantContact.id%%'),
		'bottom'=>array(
			'add'=>'/clinicalannotation/participant_contacts/add/%%Participant.id%%',
			'list'=>'clinicalannotation/participant_contacts/listall/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>

<?php 
/*
	$sidebars->header( $lang );
	$sidebars->cols( $ctrapp_sidebar, $lang );
	$summaries->build( $ctrapp_summary, $lang ); 
	$menus->tabs( $ctrapp_menu, $lang ); 
	*/
?>
	
	<?php 
	/*
		$form_type = 'index';
		$form_model = $participant_contacts;
		$form_field = $ctrapp_form;
		$form_link = array( 'add'=>'/clinicalannotation/participant_contacts/add/'.$participant_id.'/', 'detail'=>'/clinicalannotation/participant_contacts/detail/'.$participant_id.'/' );
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
	*/
	?>
