<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/diagnoses/add/'.$atim_menu_variables['Participant.id'].'/',
		'bottom'=>array(
			'add'=>'/clinicalannotation/diagnoses/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>