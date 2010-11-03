<?php 
	$structure_links = array(
		'top'=>'/customize/preferences/edit',
		'bottom'=>array(
			'cancel'=>'/customize/preferences/index'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>