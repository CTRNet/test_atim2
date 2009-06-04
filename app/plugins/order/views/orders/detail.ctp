<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/order/orders/listall/',
			'edit'=>'/order/orders/edit/%%Order.id%%/',
			'delete'=>'/order/orders/delete/%%Order.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>