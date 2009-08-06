<?php 
	$structure_links = array(
		'bottom'=>array(
			'search'=>'/clinicalannotation/participants/index',
			'delete'=>'/clinicalannotation/participants/delete/%%Participant.id%%',
			'edit'=>'/clinicalannotation/participants/edit/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>