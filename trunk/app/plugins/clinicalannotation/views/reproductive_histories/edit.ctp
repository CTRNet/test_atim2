<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/reproductive_histories/edit/'.$atim_menu_variables['Participant.id'].'/%%ReproductiveHistory.id%%/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/reproductive_histories/detail/'.$atim_menu_variables['Participant.id'].'/%%ReproductiveHistory.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>
