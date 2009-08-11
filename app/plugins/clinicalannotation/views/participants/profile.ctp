<?php 
	$structure_links = array(
		'bottom'=>array(
			'search'=>'/clinicalannotation/participants/index/',
			'list'=>'/clinicalannotation/participants/listall/',
			'edit'=>'/clinicalannotation/participants/edit/%%Participant.id%%'
			'delete'=>'/clinicalannotation/participants/delete/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>