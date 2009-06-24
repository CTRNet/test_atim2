<?php 
	
	$structure_links = array(
		'top'=>'/clinicalannotation/event_masters/edit/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id'],
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/event_masters/detail/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id']
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
	
?>