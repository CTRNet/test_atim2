<?php 
	$structure_links = array(
		'top'=>'/inventorymanagement/collections/edit/%%Collection.id%%',
		'bottom'=>array(
			'delete'=>'/inventorymanagement/collections/delete/%%Collection.id%%',
			'cancel'=>'/inventorymanagement/collections/profile/%%Collection.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>