<?php
	$structure_links = array(
		'top'=>'/clinicalannotation/consents/detail/'.$atim_menu_variables['Participant.id'].'/%%Consent.id%%',
		'bottom'=>array(
			'add'=>'/clinicalannotation/consents/add/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>