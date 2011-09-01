<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/participant_contacts/edit/'.$atim_menu_variables['Participant.id'].'/%%ParticipantContact.id%%/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/participant_contacts/detail/'.$atim_menu_variables['Participant.id'].'/%%ParticipantContact.id%%/'
		)
	);
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>