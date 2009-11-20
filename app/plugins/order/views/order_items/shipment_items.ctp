<?php 
	$structure_links = array(
		'index'=>array('Remove'=>'/order/order_items/deleteFromShipment/'.$atim_menu_variables['Order.id'].'/%%OrderItem.id%%/'),
		'bottom'=>array('add' => '/order/order_items/addToShipment/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/')
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>
