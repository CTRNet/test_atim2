<?php
	$structure_links = array(
		'top'=>array('search'=>'/provider/providers/search/'),
		'bottom'=>array(
			'add'=>'/provider/providers/add/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'search','links'=>$structure_links) );
?>