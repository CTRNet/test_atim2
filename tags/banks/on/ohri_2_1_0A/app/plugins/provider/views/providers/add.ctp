<?php 
	$structure_links = array(
		'top'=>'/provider/providers/add/',
		'bottom'=>array(
			'cancel'=>'/provider/providers/listall/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>