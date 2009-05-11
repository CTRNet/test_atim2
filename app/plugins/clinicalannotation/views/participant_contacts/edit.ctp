<?php
	$structure_links = array(
		'top'=>'/clinicalannotation/participant_contacts/edit/%%Participant.id%%/%%ParticipantContact.id%%/',
		'bottom'=>array(
			'delete'=>'/clinicalannotation/participant_contacts/delete/%%Participant.id%%/%%ParticipantContact.id%%/',
			'cancel'=>'/clinicalannotation/participant_contacts/detail/%%Participant.id%%/%%ParticipantContact.id%%'/
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
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
		$form_type = 'edit';
		$form_model = isset( $this->params['data'] ) ? array( $this->params['data'] ) : array( $data );
		$form_field = $ctrapp_form;
		$form_link = array( 'edit'=>'/clinicalannotation/participant_contacts/edit/'.$participant_id.'/', 'cancel'=>'/clinicalannotation/participant_contacts/detail/'.$participant_id.'/' );
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
*/			
	?>
		
