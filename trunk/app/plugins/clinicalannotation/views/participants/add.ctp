<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/participants/add',
		'bottom'=>array(
			'list'=>'/clinicalannotation/participants/listall/',
			'cancel'=>'/clinicalannotation/participants/index'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>