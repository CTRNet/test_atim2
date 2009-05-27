<?php
	$structure_links = array(
		'top'=>'/material/materials/detail/%%Material.id%%/',
		'bottom'=>array(
			'add'=>'/material/materials/add/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>