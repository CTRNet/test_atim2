<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/participants/edit/'.$atim_menu_variables['Participant.id'],
		'bottom'=>array(
			'list'=>'/clinicalannotation/participants/listall/',
			'cancel'=>'/clinicalannotation/participants/profile/'.$atim_menu_variables['Participant.id']
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>