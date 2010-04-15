<?php
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/clinicalannotation/participant_contacts/detail/'.$atim_menu_variables['Participant.id'].'/%%ParticipantContact.id%%',
		'bottom'=>array(
			'add'=>'/clinicalannotation/participant_contacts/add/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>