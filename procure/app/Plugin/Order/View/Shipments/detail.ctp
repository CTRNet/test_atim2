<?php 
	// 1- SHIPMENT DETAILS
	
	$structure_links = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'settings' => array('actions' => false), );
	
	if($is_from_tree_view) {
		$final_options['links']['bottom'] = array(
			'edit' => '/Order/Shipments/edit/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/',
			'add items to shipment' => array('link' => '/Order/Shipments/addToShipment/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/', 'icon' => 'add_to_shipment'),
			'delete' => '/Order/Shipments/delete/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/'
		);
		$final_options['settings']['header'] =   __('shipping');
		$final_options['settings']['actions'] =  true;
	}
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
	// 2- SHIPPED ITEMS
	if(!$is_from_tree_view) {
		$structure_links['index'] = array(
			'aliquot details' => array(
				'link' => '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/',
				'icon' => 'aliquot'),
			'remove'=>'/Order/Shipments/deleteFromShipment/%%OrderLine.order_id%%/%%OrderItem.id%%/%%Shipment.id%%/',
		);
	
		$structure_links['bottom'] = array(
			'new search' => OrderAppController::$search_links,
			'edit' => '/Order/Shipments/edit/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/',
			'add items to shipment' => array('link' => '/Order/Shipments/addToShipment/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/', 'icon' => 'add_to_shipment'),
			'delete' => '/Order/Shipments/delete/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/'
		);
		
		$final_atim_structure = $atim_structure_for_shipped_items; 
		$final_options = array(
			'type'		=>'index', 
			'data'		=> $shipped_items, 
			'links'		=> $structure_links, 
			'settings'	=> array(
				'header'	=> __('order_shipment items', null),
				'batchset'	=> array('link' => '/Order/Shipments/detail/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'], 'var' => 'aliquots_for_batchset')
			)
		);
		
		// CUSTOM CODE
		$hook_link = $this->Structures->hook('items');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		// BUILD FORM
		$this->Structures->build( $final_atim_structure, $final_options );
	}
	
?>