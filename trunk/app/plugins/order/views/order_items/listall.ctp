<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/order/order_items/detail/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/%%OrderItem.id%%/'),
		'bottom'=>array(
			'add'=>'/order/order_items/add/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>
