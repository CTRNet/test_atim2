<?php
	$structure_links = array(
		'top'=>'/drug/drugs/detail/',
		'bottom'=>array(
			'add'=>'/drug/drugs/add/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>