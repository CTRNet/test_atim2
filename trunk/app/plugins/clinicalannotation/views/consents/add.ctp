<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/consents/add/'.$atim_menu_variables['Participant.id'].'/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/consents/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structure_override = array('Consent.facility'=>$facility_id_findall);
	$structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>