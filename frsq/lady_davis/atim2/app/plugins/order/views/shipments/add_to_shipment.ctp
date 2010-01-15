<?php
	
	$structure_links = array(
		'top'=>'/order/shipments/addToShipment/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/',
		'checklist'=> array('order_item_id][' => '%%OrderItem.id%%'),//the extra ][Êafter the key makes the checklist work
		'bottom'=>array('cancel' => '/order/shipments/shipmentItems/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/')
	);
	
	$structure_settings = array(
		'form_inputs' => false,
		'pagination' => false
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'checklist','links'=>$structure_links, 'settings' => $structure_settings);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>