<?php 
	$structure_links = array(
		'top'=>NULL,
		'bottom'=>array(
			'edit'=>'/clinicalannotation/participant_contacts/edit/'.$atim_menu_variables['Participant.id'].'/%%ParticipantContact.id%%/',
			'delete'=>'/clinicalannotation/participant_contacts/delete/'.$atim_menu_variables['Participant.id'].'/%%ParticipantContact.id%%/',
			'list'=>'/clinicalannotation/participant_contacts/listall/'.$atim_menu_variables['Participant.id'].'/'
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