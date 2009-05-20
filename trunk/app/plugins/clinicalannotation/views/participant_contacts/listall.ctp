<?php
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/clinicalannotation/participant_contacts/detail/'.$atim_menu_variables['Participant.id'].'/%%ParticipantContact.id%%',
		'bottom'=>array(
			'add'=>'/clinicalannotation/participant_contacts/add/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>