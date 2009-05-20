<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/diagnoses/edit/'.$atim_menu_variables['Participant.id'].'/%%Diagnosis.id%%/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/diagnoses/detail/'.$atim_menu_variables['Participant.id'].'/%%Diagnosis.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>
