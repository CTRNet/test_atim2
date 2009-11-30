<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/participant_messages/edit/'.$atim_menu_variables['Participant.id'].'/%%ParticipantMessage.id%%/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/participant_messages/detail/'.$atim_menu_variables['Participant.id'].'/%%ParticipantMessage.id%%/'
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
