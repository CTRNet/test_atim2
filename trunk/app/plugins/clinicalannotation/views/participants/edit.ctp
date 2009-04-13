<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/participants/edit/%%Participant.id%%',
		'bottom'=>array(
			'delete'=>'/clinicalannotation/participants/delete/%%Participant.id%%',
			'cancel'=>'/clinicalannotation/participants/profile/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>