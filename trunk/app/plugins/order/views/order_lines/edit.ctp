<?php 
	$structure_links = array(
		'top'=>'/order/order_lines/edit/'.$atim_menu_variables['Order.id'].'/%%OrderLine.id%%/',
		'bottom'=>array(
			'cancel'=>'/order/order_lines/detail/'.$atim_menu_variables['Order.id'].'/%%OrderLine.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>