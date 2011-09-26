<?php 

	$search_type_links = array();
	$search_type_links['order'] = array('link'=> '/order/orders/index/', 'icon' => 'search');
	$search_type_links['order item'] = array('link'=> '/order/order_items/index/', 'icon' => 'search');
	$search_type_links['shipment'] = array('link'=> '/order/shipments/index/', 'icon' => 'search');
	
	// 1- ORDER DETAIL	
	
	$structure_links = array(
		'index'=>array(),
		'bottom'=>array(
			'edit'=>'/order/orders/edit/' . $atim_menu_variables['Order.id'] . '/',
			'add order line'=>'/order/order_lines/add/' . $atim_menu_variables['Order.id'] . '/',
			'add shipment'=>array('link'=> '/order/shipments/add/' . $atim_menu_variables['Order.id'] . '/', 'icon' => 'create_shipment'),
			'delete'=>'/order/orders/delete/' . $atim_menu_variables['Order.id'] . '/',
			'new search' => $search_type_links
		)
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('override'=>$structure_override, 'settings' => array('actions' => false), 'data' => $order_data);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
	
	// 2- ORDER LINES
	
	$structure_links['index'] = array(	
		'detail'=>'/order/order_lines/detail/%%Order.id%%/%%OrderLine.id%%/',
		'add order line item'=>array('link'=>'/order/order_items/add/%%Order.id%%/%%OrderLine.id%%/','icon'=>'add_to_order')
	);
	
	$structure_override = array();

	$final_atim_structure = $orderlines_listall_structure; 
	$final_options = array('type'=>'index', 'links'=>$structure_links, 'override'=>$structure_override, 'data' => $order_lines_data, 'settings' => array('header' => __('order_order lines', null)));
		
	// CUSTOM CODE
	$hook_link = $structures->hook('order_lines');
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
	
?>