<?php 
	$structure_links = array(
		'top'=>'/order/shipments/edit/'.$atim_menu_variables['Order.id'].'/%%Shipment.id%%/',
		'bottom'=>array(
			'cancel'=>'/order/shipments/detail/'.$atim_menu_variables['Order.id'].'/%%Shipment.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>