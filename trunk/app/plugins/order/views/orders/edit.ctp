<?php 
	$structure_links = array(
		'top'=>'/order/orders/edit/%%Order.id%%/',
		'bottom'=>array(
			'cancel'=>'/order/orders/detail/%%Order.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>