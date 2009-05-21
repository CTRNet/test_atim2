<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/clinicalannotation/participant_messages/listall/'.$atim_menu_variables['Participant.id'].'/',
			'edit'=>'/clinicalannotation/participant_messages/edit/'.$atim_menu_variables['Participant.id'].'/%%ParticipantMessage.id%%/',
			'delete'=>'/clinicalannotation/participant_messages/delete/'.$atim_menu_variables['Participant.id'].'/%%ParticipantMessage.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>