<?php 
	
	$structure_links = array(
		'top'=>'/clinicalannotation/event_masters/add/'.$atim_menu_variables['Menu.id'].'/'.$atim_menu_variables['EventControl.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventControl.id'],
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/event_masters/listall/'.$atim_menu_variables['Menu.id'].'/'.$atim_menu_variables['EventControl.event_group'].'/'.$atim_menu_variables['Participant.id']
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
	
?>