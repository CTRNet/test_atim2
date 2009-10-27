<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/diagnosis_masters/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['tableId'].'/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/diagnosis_masters/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>