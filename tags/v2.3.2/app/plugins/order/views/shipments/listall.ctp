<?php
	$structure_links = array(
		'top'=>null,
		'index'=> array(
			'detail' => '/order/shipments/detail/%%Shipment.order_id%%/%%Shipment.id%%/',
			'add items to shipment' => array('link'=> '/order/shipments/addToShipment/%%Shipment.order_id%%/%%Shipment.id%%/', 'icon' => 'add_to_shipment')),
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