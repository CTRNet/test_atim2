<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/participants/edit/%%Participant.id%%',
		'bottom'=>array(
			'list'=>'/clinicalannotation/participants/listall/',
			'cancel'=>'/clinicalannotation/participants/profile/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>