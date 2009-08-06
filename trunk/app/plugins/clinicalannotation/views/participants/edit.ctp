<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/participants/edit/%%Participant.id%%',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/participants/profile/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>