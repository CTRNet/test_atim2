<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/consents/edit/%%Participant.id%%/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/consents/detail/%%Participant.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>