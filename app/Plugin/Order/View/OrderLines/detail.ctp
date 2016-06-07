<?php 
	
	$structure_links = array(
		'bottom'=>array(
			'new search' => OrderAppController::$search_links,
			'edit'=>'/Order/OrderLines/edit/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'],
			'delete'=>'/Order/OrderLines/delete/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'],
			'order items' => array(),
			'shipments' => array(
				'add'=>array('link'=>'/Order/Shipments/add/' . $atim_menu_variables['Order.id'] . '/','icon'=>'create_shipment'))
		)
	);
	//Add item links management
	switch(Configure::read('order_item_type_config')) {
		case '1':
			$structure_links['bottom']['order items'][__('add items to order').' : '.__('tma slide')] =  array('link'=>'/Order/OrderItems/add/' . $atim_menu_variables['Order.id'] . '/'.$atim_menu_variables['OrderLine.id'].'/TmaSlide', 'icon'=>'add_to_order');
			$structure_links['bottom']['order items'][__('add items to order').' : '.__('aliquot')] =  array('link'=>'/Order/OrderItems/add/' . $atim_menu_variables['Order.id'] . '/'.$atim_menu_variables['OrderLine.id'].'/AliquotMaster', 'icon'=>'add_to_order');
			break;
		case '2':
			$structure_links['bottom']['order items'][__('add items to order').' : '.__('aliquot')] =  array('link'=>'/Order/OrderItems/add/' . $atim_menu_variables['Order.id'] . '/'.$atim_menu_variables['OrderLine.id'].'/AliquotMaster', 'icon'=>'add_to_order');
			break;
		case '3':
			$structure_links['bottom']['order items'][__('add items to order').' : '.__('tma slide')] =  array('link'=>'/Order/OrderItems/add/' . $atim_menu_variables['Order.id'] . '/'.$atim_menu_variables['OrderLine.id'].'/TmaSlide', 'icon'=>'add_to_order');
			break;
	}
	$structure_links['bottom']['order items']['define order items returned'] =  array('link' => '/Order/OrderItems/defineOrderItemsReturned/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/', 'icon'=>'order items returned');	
	//Add to shipment links management
	$add_to_shipment_links = array();
	foreach ($shipments_list as $shipment) {	
		$add_to_shipment_links[$shipment['Shipment']['shipment_code']] = array(
			'link'=> '/Order/Shipments/addToShipment/' . $shipment['Shipment']['order_id'] . '/' . $shipment['Shipment']['id'] . '/' .$atim_menu_variables['OrderLine.id'],
			'icon' => 'add_to_shipment');
	}
	ksort($add_to_shipment_links);
	foreach($add_to_shipment_links as $shipment_key => $shipment_link) $structure_links['bottom']['shipments'][__('add items to shipment').' # '.$shipment_key] = $shipment_link;
	
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
	
	$counter = 0;
	$all_status = array('pending', 'shipped', 'shipped & returned');
	foreach($all_status as $status) {
		$counter++;
		$final_atim_structure = array();
		$final_options = array(
			'links'	=> $structure_links,
			'settings' => array(
				'language_heading' => __($status, null),
				'actions'	=> false,
			), 'extras' => array('end' => $this->Structures->ajaxIndex('Order/OrderItems/listall/'.$atim_menu_variables['Order.id'].'/'.$status.'/'.$atim_menu_variables['OrderLine.id'].'/'))
		);
		if($counter == 1) $final_options['settings']['header'] = __('order items', null);
		if($counter == sizeof($all_status)) $final_options['settings']['actions'] = true;
	
		// CUSTOM CODE
		$hook_link = $this->Structures->hook('line_items');
		if( $hook_link ) {
			require($hook_link);
		}
	
		// BUILD FORM
		$this->Structures->build( $final_atim_structure, $final_options );
	}
