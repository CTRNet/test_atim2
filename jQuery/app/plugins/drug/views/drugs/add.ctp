<?php 
	$structure_links = array(
		'top'=>'/drug/drugs/add/',
		'bottom'=>array(
			'cancel'=>'/drug/drugs/listall/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>