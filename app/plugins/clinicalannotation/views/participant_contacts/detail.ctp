<?php 
	$structure_links = array(
		'top'=>NULL,
		'bottom'=>array(
			'list'=>'/clinicalannotation/participant_contacts/listall/'.$atim_menu_variables['Participant.id'].'/',
			'edit'=>'/clinicalannotation/participant_contacts/edit/'.$atim_menu_variables['Participant.id'].'/%%ParticipantContact.id%%/',
			'delete'=>'/clinicalannotation/participant_contacts/delete/'.$atim_menu_variables['Participant.id'].'/%%ParticipantContact.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>