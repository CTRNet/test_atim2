<?php 
	$structure_links = array(
		'top'=>NULL,
		'bottom'=>array(
			'list'=>'/clinicalannotation/consents/listall/'.$atim_menu_variables['Participant.id'].'/',
			'edit'=>'/clinicalannotation/consents/edit/'.$atim_menu_variables['Participant.id'].'/%%Consent.id%%/',
			'delete'=>'/clinicalannotation/consents/delete/'.$atim_menu_variables['Participant.id'].'/%%Consent.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>