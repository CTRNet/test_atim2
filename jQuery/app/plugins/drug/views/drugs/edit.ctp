<?php 
	$structure_links = array(
		'top'=>'/drug/drugs/edit/%%Drug.id%%/',
		'bottom'=>array(
			'cancel'=>'/drug/drugs/detail/%%Drug.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>