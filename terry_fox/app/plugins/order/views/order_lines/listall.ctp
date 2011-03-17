<?php 
	
	$structure_links = array(
		'index'=>array(
			'detail'=>'/order/order_lines/detail/%%Order.id%%/%%OrderLine.id%%/',
			'add order line item'=>array('link'=>'/order/order_items/add/%%Order.id%%/%%OrderLine.id%%/','icon'=>'add_to_order')
		),
		'bottom'=>array(
			'add order line'=>'/order/order_lines/add/'.$atim_menu_variables['Order.id'].'/',
			'add shipment'=>array('link'=>'/order/shipments/add/' . $atim_menu_variables['Order.id'] . '/','icon'=>'create_shipment')
		)
	);
	
	$structure_override = array();

	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links,'override'=>$structure_override, 'data'=>$order_lines_data);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
?>
