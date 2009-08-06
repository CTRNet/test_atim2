<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/consents/edit/'.$atim_menu_variables['Participant.id'].'/%%Consent.id%%/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/consents/detail/'.$atim_menu_variables['Participant.id'].'/%%Consent.id%%/'
		)
	);
	
	$structure_override = array('Consent.facility'=>$facility_id_findall);
	$structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>