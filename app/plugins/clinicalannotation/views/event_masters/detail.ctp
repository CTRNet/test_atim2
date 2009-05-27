<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/clinicalannotation/event_masters/edit/'.$atim_menu_variables['Participant.id'], 
			'delete'=>'/clinicalannotation/event_masters/delete/'.$atim_menu_variables['Participant.id'], 
			'list'=>'/clinicalannotation/event_masters/detail/'.$atim_menu_variables['Participant.id']
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>