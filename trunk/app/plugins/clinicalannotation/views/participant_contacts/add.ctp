<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/participant_contacts/add/'.$atim_menu_variables['Participant.id'].'/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/participant_contacts/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>