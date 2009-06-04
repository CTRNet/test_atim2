<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/order/order_items/listall/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/',
			'edit'=>'/order/order_items/edit/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/%%OrderItem.id%%/',
			'delete'=>'/order/order_items/delete/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/%%OrderItem.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>