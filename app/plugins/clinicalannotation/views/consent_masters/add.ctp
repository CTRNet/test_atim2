<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/consent_masters/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['ConsentControl.id'].'/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/consent_masters/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	$structure_override = array('Consent.facility'=>$facility_id_findall);
	$structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>