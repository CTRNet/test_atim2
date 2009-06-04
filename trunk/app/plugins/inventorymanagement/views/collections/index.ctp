<?php 

	$structure_links = array(
		'top'=>'/inventorymanagement/collections/search',
		'bottom'=>array(
			'add'=>'/inventorymanagement/collections/add'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'search','links'=>$structure_links) );

?>