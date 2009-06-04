<?php 
	$structure_links = array(
		'top'=>'/order/order_lines/add/'.$atim_menu_variables['Order.id'].'/',
		'bottom'=>array(
			'cancel'=>'/order/order_lines/listall/'.$atim_menu_variables['Order.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>