<?php
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/order/orders/detail/%%Order.id%%/',
		'bottom'=>array(
			'add'=>'/order/orders/add/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>