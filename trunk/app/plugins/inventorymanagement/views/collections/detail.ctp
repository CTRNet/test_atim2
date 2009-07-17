<?php 
	$structure_links = array(
		'bottom'=>array(
			'search'=>'/inventorymanagement/collections/index',
			'edit'=>'/inventorymanagement/collections/edit/%%Collection.id%%', 
			'delete'=>'/inventorymanagement/collections/delete/%%Collection.id%%'
		)
	);
	
	$structure_override = array('Collection.bank_id'=>$bank_id_findall);
	$structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>