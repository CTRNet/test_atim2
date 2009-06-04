<?php
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/order/shipments/detail/'.$atim_menu_variables['Order.id'].'/%%Shipment.id%%',
		'bottom'=>array(
			'add'=>'/order/shipments/add/'.$atim_menu_variables['Order.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>