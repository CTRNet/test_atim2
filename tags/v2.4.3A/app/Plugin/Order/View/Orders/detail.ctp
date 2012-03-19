<?php 

	// 1- ORDER DETAIL	
	
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
	
	
	// 2- ORDER LINES
	
	$structure_links['index'] = array(	
		'detail'=>'/Order/OrderLines/detail/%%Order.id%%/%%OrderLine.id%%/',
		'add order line item'=>array('link'=>'/Order/OrderItems/add/%%Order.id%%/%%OrderLine.id%%/','icon'=>'add_to_order')
	);
	
	$structure_override = array();

	$final_atim_structure = $orderlines_listall_structure; 
	$final_options = array('type'=>'index', 'links'=>$structure_links, 'override'=>$structure_override, 'data' => $order_lines_data, 'settings' => array('header' => __('order_order lines', null)));
		
	// CUSTOM CODE
	$hook_link = $this->Structures->hook('order_lines');
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	
	
?>