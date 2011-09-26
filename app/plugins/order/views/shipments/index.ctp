<?php 

	$search_type_links = array();
	$search_type_links['order'] = array('link'=> '/order/orders/index/', 'icon' => 'search');
	$search_type_links['order item'] = array('link'=> '/order/order_items/index/', 'icon' => 'search');
	$search_type_links['shipment'] = array('link'=> '/order/shipments/index/', 'icon' => 'search');
		
	$structure_links = array(
		'top' => '/order/shipments/search',
		'bottom' => array('add order' => '/order/orders/add/', 'new search' => $search_type_links)
	);

	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'search', 'links' => $structure_links, 'override' => $structure_override, 'settings' => array('header' => __('search type', null).': '.__('shipment', null)));
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	

	
?>