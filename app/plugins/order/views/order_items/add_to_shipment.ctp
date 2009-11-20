<?php
	
	$structure_links = array(
		'top'=>'/order/order_items/addToShipment/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/',
		'checklist'=> array('foo][' => '%%OrderItem.id%%'),//the extra ][Êafter the key makes the checklist work
		'bottom'=>array('cancel' => '/order/order_items/shipment_items/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/')
	);
	
	$structure_settings = array(
		'form_inputs' => false,
		'pagination' => false
	);
	
	$structures->build( $atim_structure, array('type'=>'checklist','links'=>$structure_links, 'settings' => $structure_settings) );
?>
