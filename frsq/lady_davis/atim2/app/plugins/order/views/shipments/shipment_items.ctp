<?php 
	$structure_links = array(
		'index'=>array('remove'=>'/order/shipments/deleteFromShipment/'.$atim_menu_variables['Order.id'].'/%%OrderItem.id%%/'.$atim_menu_variables['Shipment.id'].'/'),
		'bottom'=>array('add' => '/order/shipments/addToShipment/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/')
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>
