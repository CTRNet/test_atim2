<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/reproductive_histories/add/'.$atim_menu_variables['Participant.id'].'/',
		'bottom'=>array(
			'add'=>'/clinicalannotation/reproductive_histories/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>