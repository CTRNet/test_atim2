<?php 
	
	$add_to_shipment_links = array();
	foreach ($shipments_list as $shipment) {	
		$add_to_shipment_links[$shipment['Shipment']['shipment_code']] = array(
			'link'=> '/Order/Shipments/addToShipment/' . $shipment['Shipment']['order_id'] . '/' . $shipment['Shipment']['id'],
			'icon' => 'add_to_shipment');
	}
	ksort($add_to_shipment_links);
	
	$structure_links = array(
		'bottom'=>array(
			'new search' => OrderAppController::$search_links,
			'edit'=>'/Order/OrderLines/edit/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'],
			'add order line item'=>array('link'=>'/Order/OrderItems/add/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/','icon'=>'add_to_order'),
			'edit all order line items' => '/Order/OrderItems/edit/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/',
			'add shipment'=>array('link'=>'/Order/Shipments/add/' . $atim_menu_variables['Order.id'] . '/','icon'=>'create_shipment'),
			'add items to shipment' => $add_to_shipment_links,
			'delete'=>'/Order/OrderLines/delete/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id']
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'settings' => array('actions' => false));
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	

	// Items list
	
	$final_atim_structure = array(); 
	$final_options = array(
		'links' => $structure_links, 
		'settings' => array('header' => __('line items', null)),
		'extras' => array('end' => $this->Structures->ajaxIndex('Order/OrderItems/listall/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/')));
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	
