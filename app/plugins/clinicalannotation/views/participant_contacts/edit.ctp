<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/participant_contacts/edit/'.$atim_menu_variables['Participant.id'].'/%%ParticipantContact.id%%/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/participant_contacts/detail/'.$atim_menu_variables['Participant.id'].'/%%ParticipantContact.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>