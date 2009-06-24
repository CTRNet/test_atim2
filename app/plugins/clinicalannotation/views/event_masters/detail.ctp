<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/clinicalannotation/event_masters/edit/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id'], 
			'delete'=>'/clinicalannotation/event_masters/delete/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id'], 
			'list'=>'/clinicalannotation/event_masters/listall/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id']
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
	
?>