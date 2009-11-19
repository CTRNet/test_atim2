<?php 
	
	$structure_links = array(
		'index'=>array('detail'=>'/order/order_items/detail/%%OrderLine.order_id%%/%%OrderLine.id%%/%%OrderItem.id%%/'),
		'bottom'=>array(
			'add'=>'/order/order_items/add/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/',
			'unshipped item'=>'/underdevelopment/',//'/order/order_items/manage_unshipped_items/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/',
			'manage shipments'=>'/underdevelopment/'//'/order/order_items/manage_shipments/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>
