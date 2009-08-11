<?php

	$structure_links = array(
		'top'=>NULL,
		'index'=>'/clinicalannotation/participants/listall/%%Participant.id%%/',
		'bottom'=>array(
			'add'=>'/clinicalannotation/participants/add/%%Participant.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>