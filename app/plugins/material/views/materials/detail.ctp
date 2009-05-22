<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/material/materials/listall/',
			'edit'=>'/material/materials/edit/%%Materials.id%%/',
			'delete'=>'/material/materials/delete/%%Materials.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>