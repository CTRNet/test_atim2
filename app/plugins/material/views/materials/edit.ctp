<?php 
	$structure_links = array(
		'top'=>'/material/materials/edit/%%Materials.id%%/',
		'bottom'=>array(
			'cancel'=>'/material/materials/detail/%%Materials.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>