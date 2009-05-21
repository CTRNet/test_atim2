<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/clinicalannotation/reproductive_histories/listall/'.$atim_menu_variables['Participant.id'].'/',
			'edit'=>'/clinicalannotation/reproductive_histories/edit/'.$atim_menu_variables['Participant.id'].'/%%ReproductiveHistory.id%%/',
			'delete'=>'/clinicalannotation/reproductive_histories/delete/'.$atim_menu_variables['Participant.id'].'/%%ReproductiveHistory.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>