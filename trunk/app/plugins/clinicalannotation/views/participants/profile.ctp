<?php 
	$structure_links = array(
		'bottom'=>array(
			'search'=>'/clinicalannotation/participants/index',
			'edit'=>'/clinicalannotation/participants/edit/%%Participant.id%%', 
			'delete'=>'/clinicalannotation/participants/delete/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>