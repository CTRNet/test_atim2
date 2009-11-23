<?php 
	$structure_links = array(
		'index'=>array('remove'=>'/order/shipments/deleteFromShipment/'.$atim_menu_variables['Order.id'].'/%%OrderItem.id%%/'.$atim_menu_variables['Shipment.id'].'/'),
		'bottom'=>array('add' => '/order/shipments/addToShipment/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/')
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>
