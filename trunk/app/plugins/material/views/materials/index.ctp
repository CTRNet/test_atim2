<?php
	$structure_links = array(
		'top'=>array('search'=>'/material/search/'),
		'bottom'=>array(
			'add'=>'/material/add/%%Material.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>