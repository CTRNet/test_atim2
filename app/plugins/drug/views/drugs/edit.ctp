<?php 
	$structure_links = array(
		'top'=>'/drug/drugs/edit/',
		'bottom'=>array(
			'cancel'=>'/drug/drugs/detail/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>