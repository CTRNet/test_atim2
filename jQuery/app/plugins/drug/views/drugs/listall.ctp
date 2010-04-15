<?php
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/drug/drugs/detail/%%Drug.id%%/',
		'bottom'=>array(
			'add'=>'/drug/drugs/add/',
			'search'=>'/drug/drugs/index/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>