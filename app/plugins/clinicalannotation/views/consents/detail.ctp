<?php 
	$structure_links = array(
		'top'=>NULL,
		'bottom'=>array(
			'edit'=>'/clinicalannotation/consents/edit/'.$atim_menu_variables['Participant.id'].'/%%Consent.id%%/',
			'delete'=>'/clinicalannotation/consents/delete/'.$atim_menu_variables['Participant.id'].'/%%Consent.id%%/',
			'list'=>'/clinicalannotation/consents/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structure_override = array('Consent.facility'=>$facility_id_findall);
	$structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>