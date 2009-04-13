<?php 

	$structure_links = array(
		'top'=>'/clinicalannotation/participants/search',
		'bottom'=>array(
			'add'=>'/clinicalannotation/participants/add'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'search','links'=>$structure_links) );

?>