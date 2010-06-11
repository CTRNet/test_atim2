<?php 
	$structure_links = array(
		'top'=>'/material/materials/add/',
		'bottom'=>array(
			'cancel'=>'/material/materials/listall/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>