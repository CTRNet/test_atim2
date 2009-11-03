<?php 
	$structure_links = array(
		'top'=>NULL,
		'bottom'=>array(
			'edit'=>'/clinicalannotation/consent_masters/edit/'.$atim_menu_variables['Participant.id'].'/%%ConsentMaster.id%%/',
			'delete'=>'/clinicalannotation/consent_masters/delete/'.$atim_menu_variables['Participant.id'].'/%%ConsentMaster.id%%/',
			'list'=>'/clinicalannotation/consent_masters/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	$structure_override = array('Consent.facility'=>$facility_id_findall);
	$structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>