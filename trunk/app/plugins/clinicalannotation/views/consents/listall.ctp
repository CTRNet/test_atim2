<?php
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/clinicalannotation/consents/detail/'.$atim_menu_variables['Participant.id'].'/%%Consent.id%%',
		'bottom'=>array(
			'add'=>'/clinicalannotation/consents/add/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structure_override = array('Consent.facility'=>$facility_id_findall);
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links,'override'=>$structure_override) );
?>