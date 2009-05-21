<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/participant_messages/add/'.$atim_menu_variables['Participant.id'].'/',
		'bottom'=>array(
			'add'=>'/clinicalannotation/participant_messages/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>