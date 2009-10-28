<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/consent_masters/edit/'.$atim_menu_variables['Participant.id'].'/%%ConsentMaster.id%%/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/consent_masters/detail/'.$atim_menu_variables['Participant.id'].'/%%ConsentMaster.id%%/'
		)
	);
	
	$structure_override = array('Consent.facility'=>$facility_id_findall);
	$structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>