<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/consents/edit/'.$atim_menu_variables['Participant.id'].'/%%Consent.id%%/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/consents/detail/'.$atim_menu_variables['Participant.id'].'/%%Consent.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>