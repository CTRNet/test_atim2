<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/order/shipments/listall/'.$atim_menu_variables['Order.id'].'/',
			'edit'=>'/order/shipments/edit/'.$atim_menu_variables['Order.id'].'/%%Shipment.id%%/',
			'delete'=>'/order/shipments/delete/'.$atim_menu_variables['Order.id'].'/%%Shipment.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>