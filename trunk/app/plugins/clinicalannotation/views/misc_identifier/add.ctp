<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/misc_identifiers/add/'.$atim_menu_variables['Participant.id'].'/',
		'bottom'=>array(
			'add'=>'/clinicalannotation/misc_identifiers/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>