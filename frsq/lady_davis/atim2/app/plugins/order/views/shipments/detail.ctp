<?php 
	
	// 1- SHIPMENT DETAILS
	
	$structure_links = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'settings' => array('actions' => false), );
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
	// 2- SHIPPED ITEMS
	
	$structure_links['index'] = array(
		'aliquot details' => array(
			'link' => '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/',
			'icon' => 'aliquot'),
		'remove'=>'/order/shipments/deleteFromShipment/%%OrderLine.order_id%%/%%OrderItem.id%%/%%Shipment.id%%/',
	);

	$structure_links['bottom'] = array(
		'edit' => '/order/shipments/edit/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/',
		'add items to shipment' => '/order/shipments/addToShipment/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/',
		'delete' => '/order/shipments/delete/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/'
	);
	
	$structure_override = array();
	
	$sample_types = array();
	foreach($sample_controls_list as $new_control) {
		$sample_types[$new_control['SampleControl']['id']] = __($new_control['SampleControl']['sample_type'], null);
	}
	$structure_override['OrderLine.sample_control_id'] = $sample_types;
	
	$aliquot_types = array();
	foreach($aliquot_controls_list as $new_control) {
		$aliquot_types[$new_control['AliquotControl']['id']] = __($new_control['AliquotControl']['aliquot_type'], null);
	}
	$structure_override['OrderLine.aliquot_control_id'] = $aliquot_types;

	$final_atim_structure = $atim_structure_for_shipped_items; 
	$final_options = array('type'=>'index', 'data' => $shipped_items, 'links'=>$structure_links, 'override' => $structure_override, 'settings' => array('header' => __('order_shipment items', null), 'separator' => true));
	
	// CUSTOM CODE
	$hook_link = $structures->hook('items');
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
		
?>