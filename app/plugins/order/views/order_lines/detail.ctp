<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/order/order_lines/listall/'.$atim_menu_variables['Order.id'].'/',
			'edit'=>'/order/order_lines/edit/'.$atim_menu_variables['Order.id'].'/%%OrderLine.id%%/',
			'delete'=>'/order/order_lines/delete/'.$atim_menu_variables['Order.id'].'/%%OrderLine.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>