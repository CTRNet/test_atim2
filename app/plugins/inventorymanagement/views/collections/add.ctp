<?php 
	$structure_links = array(
		'top'=>'/inventorymanagement/collections/add',
		'bottom'=>array(
			'cancel'=>'/inventorymanagement/collections/index'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>