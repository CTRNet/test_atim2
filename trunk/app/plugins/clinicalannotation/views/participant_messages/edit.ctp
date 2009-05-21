<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/participant_messages/edit/'.$atim_menu_variables['Participant.id'].'/%%ParticipantMessage.id%%/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/participant_messages/detail/'.$atim_menu_variables['Participant.id'].'/%%ParticipantMessage.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>
