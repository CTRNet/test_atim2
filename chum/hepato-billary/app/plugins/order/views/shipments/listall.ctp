<?php
	$structure_links = array(
		'top'=>null,
		'index'=> array(
			'add items to shipment' => '/order/shipments/addToShipment/%%Shipment.order_id%%/%%Shipment.id%%/',
			'detail' => '/order/shipments/detail/%%Shipment.order_id%%/%%Shipment.id%%/'),
		'bottom'=>array(
			'add'=>'/order/shipments/add/'.$atim_menu_variables['Order.id'].'/'
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>