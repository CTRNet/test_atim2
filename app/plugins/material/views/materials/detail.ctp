<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/material/materials/listall/',
			'edit'=>'/material/materials/edit/%%Material.id%%/',
			'delete'=>'/material/materials/delete/%%Material.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>