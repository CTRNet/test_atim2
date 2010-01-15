<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/order/order_items/listall/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/',
			'edit'=>'/order/order_items/edit/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/%%OrderItem.id%%/',
			'delete'=>'/order/order_items/delete/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/%%OrderItem.id%%/'
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
?>