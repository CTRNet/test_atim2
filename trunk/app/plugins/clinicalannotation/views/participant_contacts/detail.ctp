<?php 
	$structure_links = array(
		'top'=>NULL,
		'bottom'=>array(
			'edit'=>'/clinicalannotation/participant_contacts/edit/'.$atim_menu_variables['Participant.id'].'/%%ParticipantContact.id%%/',
			'delete'=>'/clinicalannotation/participant_contacts/delete/'.$atim_menu_variables['Participant.id'].'/%%ParticipantContact.id%%/',
			'list'=>'/clinicalannotation/participant_contacts/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>