<?php 
	// 1- SHIPMENT DETAILS



	$add_items_to_shipment_link = array('link' => '/Order/Shipments/addToShipment/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/', 'icon' => 'add_to_shipment');
	if($add_to_shipments_subset_limits) {
		$add_items_to_shipment_link = array();
		foreach($add_to_shipments_subset_limits as $key => $sub_set_data) {
			list($start, $limit) = $sub_set_data;
			$add_items_to_shipment_link[__('batchset').' #'.$key] = array('link' => '/Order/Shipments/addToShipment/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id']."/0/$start/$limit", 'icon' => 'add_to_shipment');
			
		}
	}
	$structure_links = array(
		'bottom' => array(
			'edit' => '/Order/Shipments/edit/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/',
			'delete' => '/Order/Shipments/delete/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/',
			'order items' => array(
				'define order items returned' => array('link' => '/Order/OrderItems/defineOrderItemsReturned/'.$atim_menu_variables['Order.id'].'/0/'.$atim_menu_variables['Shipment.id'], 'icon'=>'order items returned')
			),
			'shipments' => array(
				'add items to shipment' => $add_items_to_shipment_link
			)
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links);
	
	if($is_from_tree_view) {
		$final_options['settings']['header'] =   __('shipping');
		$final_options['settings']['actions'] =  true;
	} else {
		$final_options['settings']['actions'] =  false;
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
		
		$structure_links['bottom'] = array_merge(array('new search' => OrderAppController::$search_links), $structure_links['bottom'] );
		
		$counter = 0;
		$all_status = array('shipped', 'shipped & returned');
		foreach($all_status as $status) {
			$counter++;
			$final_atim_structure = array();
			$final_options = array(
				'links'	=> $structure_links,
				'settings' => array(
					'language_heading' => __($status, null),
					'actions'	=> false,
				), 'extras' => array('end' => $this->Structures->ajaxIndex('Order/OrderItems/listall/'.$atim_menu_variables['Order.id'].'/'.$status.'/0/'.$atim_menu_variables['Shipment.id']))
			);
			if($counter == 1) $final_options['settings']['header'] = __('order items', null);
			if($counter == sizeof($all_status)) $final_options['settings']['actions'] = true;
		
			// CUSTOM CODE
			$hook_link = $this->Structures->hook('items');
			if( $hook_link ) {
				require($hook_link);
			}
		
			// BUILD FORM
			$this->Structures->build( $final_atim_structure, $final_options );
		}
				
	}
	
?>