<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/clinicalannotation/participants/edit/%%Participant.id%%', 
			'search'=>'/clinicalannotation/participants/index'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>