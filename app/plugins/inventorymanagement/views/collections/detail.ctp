<?php 
	$structure_links = array(
		'bottom'=>array(
			'search'=>'/inventorymanagement/collections/index',
			'edit'=>'/inventorymanagement/collections/edit/%%Collection.id%%', 
			'delete'=>'/inventorymanagement/collections/delete/%%Collection.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>