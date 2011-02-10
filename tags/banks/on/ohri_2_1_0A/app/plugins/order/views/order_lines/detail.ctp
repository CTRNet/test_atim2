<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/order/order_lines/edit/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'],
			'add order line item'=>'/order/order_items/add/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/',
			'add shipment'=>'/order/shipments/add/' . $atim_menu_variables['Order.id'] . '/',
			'delete'=>'/order/order_lines/delete/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id']
		)
	);
	
	$structure_override = array();

	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links,'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
?>