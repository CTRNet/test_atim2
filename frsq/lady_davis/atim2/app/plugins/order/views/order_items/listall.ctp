<?php 

	$structure_links = array(
		'bottom'=>array(
			'edit all' => '/order/order_items/edit/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/',
			'add item'=> '/order/order_items/add/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/',
			'add shipment'=>'/order/shipments/add/' . $atim_menu_variables['Order.id'] . '/'
		)
	);
	
	$structure_links['index'] = array(
		'aliquot details' => array(
				'link' => '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/',
				'icon' => 'aliquot'),
		'delete' => '/order/order_items/delete/%%OrderLine.order_id%%/%%OrderLine.id%%/%%OrderItem.id%%/');
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links, 'data' => $order_items_data);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>
