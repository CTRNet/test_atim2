<?php
	$structure_links = array(
		'top'=>array('search'=>'/material/materials/search/'),
		'bottom'=>array(
			'add'=>'/material/materials/add/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'search','links'=>$structure_links) );
?>