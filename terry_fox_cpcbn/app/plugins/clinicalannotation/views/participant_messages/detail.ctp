<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/clinicalannotation/participant_messages/listall/'.$atim_menu_variables['Participant.id'].'/',
			'edit'=>'/clinicalannotation/participant_messages/edit/'.$atim_menu_variables['Participant.id'].'/%%ParticipantMessage.id%%/',
			'delete'=>'/clinicalannotation/participant_messages/delete/'.$atim_menu_variables['Participant.id'].'/%%ParticipantMessage.id%%/'
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