<?php 

	// ----- ORDER DETAIL -----	
	
	$structure_links = array(
		'index'=>array(),
		'bottom'=>array(
			'new search' => OrderAppController::$search_links,
			'edit'=>'/Order/orders/edit/' . $atim_menu_variables['Order.id'] . '/',
			'add order line'=>'/Order/OrderLines/add/' . $atim_menu_variables['Order.id'] . '/',
			'add shipment'=>array('link'=> '/Order/shipments/add/' . $atim_menu_variables['Order.id'] . '/', 'icon' => 'create_shipment'),
			'delete'=>'/Order/orders/delete/' . $atim_menu_variables['Order.id'] . '/'
		)
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('override'=>$structure_override, 'settings' => array('actions' => false), 'data' => $order_data);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
	// ----- ORDER LINES -----
	
	$final_atim_structure = array(); 
	$final_options = array(
		'links'	=> $structure_links,
		'settings' => array(
			'header' => __('order_order lines', null),
			'actions'	=> false,
		), 'extras' => array('end' => $this->Structures->generateIndex('Order/OrderLines/listall/'.$atim_menu_variables['Order.id']))
	);
		
	// CUSTOM CODE
	$hook_link = $this->Structures->hook('order_lines');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	

	// ----- SHIPMENTS -----
	
	$final_atim_structure = array();
	$final_options = array(
			'links'	=> $structure_links,
			'settings' => array(
					'header' => __('shipments', null),
					'actions'	=> false,
			), 'extras' => array('end' => $this->Structures->generateIndex('Order/shipments/listall/'.$atim_menu_variables['Order.id'])));
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook('shipments');
	if( $hook_link ) {
		require($hook_link);
	}
	
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	
	
	// ----- ORDER ITEMS -----
	
	$final_atim_structure = array();
	$final_options = array(
			'links'	=> $structure_links,
			'settings' => array(
					'header' => __('order items', null)
			), 'extras' => array('end' => $this->Structures->generateIndex('Order/OrderItems/listall/'.$atim_menu_variables['Order.id']))
	);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook('order_items');
	if( $hook_link ) {
		require($hook_link);
	}
	
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	
