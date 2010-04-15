<?php
	$structure_links = array(
		'top'=>array('search'=>'/drug/drugs/search/'),
		'bottom'=>array(
			'add'=>'/drug/drugs/add/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'search','links'=>$structure_links) );
?>