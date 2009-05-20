<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/clinicalannotation/diagnoses/listall/'.$atim_menu_variables['Participant.id'].'/',
			'edit'=>'/clinicalannotation/diagnoses/edit/'.$atim_menu_variables['Participant.id'].'/%%Diagnosis.id%%/',
			'delete'=>'/clinicalannotation/diagnoses/delete/'.$atim_menu_variables['Participant.id'].'/%%Diagnosis.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>