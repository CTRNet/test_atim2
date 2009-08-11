<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/clinicalannotation/misc_identifiers/edit/'.$atim_menu_variables['Participant.id'].'/%%MiscIdentifier.id%%/',
			'delete'=>'/clinicalannotation/misc_identifiers/delete/'.$atim_menu_variables['Participant.id'].'/%%MiscIdentifier.id%%//',
			'list'=>'/clinicalannotation/misc_identifiers/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>