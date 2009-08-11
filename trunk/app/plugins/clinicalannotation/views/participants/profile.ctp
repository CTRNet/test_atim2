<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/clinicalannotation/participants/edit/%%Participant.id%%',
			'search'=>'/clinicalannotation/participants/index',
			'delete'=>'/clinicalannotation/participants/delete/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>