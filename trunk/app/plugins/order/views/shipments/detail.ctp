<?php 

	$search_type_links = array();
	$search_type_links['order'] = array('link'=> '/order/orders/index/', 'icon' => 'search');
	$search_type_links['order item'] = array('link'=> '/order/order_items/index/', 'icon' => 'search');
	$search_type_links['shipment'] = array('link'=> '/order/shipments/index/', 'icon' => 'search');
	
	// 1- SHIPMENT DETAILS
	
	$structure_links = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'settings' => array('actions' => false), );
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
	// 2- SHIPPED ITEMS
	
	$structure_links['index'] = array(
		'aliquot details' => array(
			'link' => '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/',
			'icon' => 'aliquot'),
		'remove'=>'/order/shipments/deleteFromShipment/%%OrderLine.order_id%%/%%OrderItem.id%%/%%Shipment.id%%/',
	);

	$structure_links['bottom'] = array(
		'edit' => '/order/shipments/edit/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/',
		'add items to shipment' => array('link' => '/order/shipments/addToShipment/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/', 'icon' => 'add_to_shipment'),
		'delete' => '/order/shipments/delete/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/',
		'new search' => $search_type_links
	);
	
	$structure_override = array();

	$final_atim_structure = $atim_structure_for_shipped_items; 
	$final_options = array('type'=>'index', 'data' => $shipped_items, 'links'=>$structure_links, 'override' => $structure_override, 'settings' => array('header' => __('order_shipment items', null), 'separator' => true));
	
	// CUSTOM CODE
	$hook_link = $structures->hook('items');
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
		
?>