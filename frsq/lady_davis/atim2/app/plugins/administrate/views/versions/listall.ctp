<?php
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/administrate/versions/detail/%%Version.id%%/',
		'bottom'=>NULL
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>