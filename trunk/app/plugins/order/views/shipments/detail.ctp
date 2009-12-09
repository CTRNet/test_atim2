<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/order/shipments/listall/'.$atim_menu_variables['Order.id'].'/',
			'edit'=>'/order/shipments/edit/'.$atim_menu_variables['Order.id'].'/%%Shipment.id%%/',
			'delete'=>'/order/shipments/delete/'.$atim_menu_variables['Order.id'].'/%%Shipment.id%%/'
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