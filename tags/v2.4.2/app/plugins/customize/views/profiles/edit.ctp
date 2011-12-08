<?php 
	$structure_links = array(
		'top'=>'/customize/profiles/edit',
		'bottom'=>array(
			'cancel'=>'/customize/profiles/index'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>