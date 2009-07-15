<?php 
	$structure_links = array(
		'top'=>'/order/order_lines/edit/'.$atim_menu_variables['Order.id'].'/%%OrderLine.id%%/',
		'bottom'=>array(
			'cancel'=>'/order/order_lines/detail/'.$atim_menu_variables['Order.id'].'/%%OrderLine.id%%/'
		)
	);
	
	$structure_override = array('OrderLine.sample_control_id'=>$sample_control_id_findall);
	$structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>