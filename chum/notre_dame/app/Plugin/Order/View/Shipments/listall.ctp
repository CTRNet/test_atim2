<?php
	$structure_links = array(
		'top'=>null,
		'index'=> array(
			'detail' => '/Order/Shipments/detail/%%Shipment.order_id%%/%%Shipment.id%%/',
			'add items to shipment' => array('link'=> '/Order/Shipments/addToShipment/%%Shipment.order_id%%/%%Shipment.id%%/', 'icon' => 'add_to_shipment'),
			'delete' => '/Order/Shipments/delete/%%Shipment.order_id%%/%%Shipment.id%%/'),
		'bottom'=>array(
			'add'=>'/Order/Shipments/add/'.$atim_menu_variables['Order.id'].'/'
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>