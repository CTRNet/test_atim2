<?php 
	$structure_links = array(
		'top'=>'/material/materials/edit/%%Material.id%%/',
		'bottom'=>array(
			'cancel'=>'/material/materials/detail/%%Material.id%%/'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>