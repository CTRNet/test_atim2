<?php 
	$structure_links = array(
		'bottom'=>array(
			'search'=>'/material/materials/index/',
			'edit'=>'/material/materials/edit/%%Material.id%%/',
			'delete'=>'/material/materials/delete/%%Material.id%%/'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>