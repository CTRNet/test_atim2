<?php 
	$structure_links = array(
		'top'=>'/order/order_items/edit/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/%%OrderItem.id%%/',
		'bottom'=>array(
			'cancel'=>'/order/order_items/detail/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/%%OrderItem.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>