<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/family_histories/edit/'.$atim_menu_variables['Participant.id'].'/%%FamilyHistory.id%%/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/family_histories/detail/'.$atim_menu_variables['Participant.id'].'/%%FamilyHistory.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>
