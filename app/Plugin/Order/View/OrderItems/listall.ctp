<?php 

	$structure_links = array(
		'bottom'=>array(
			'new search' => OrderAppController::$search_links,
			'edit all' => '/Order/OrderItems/edit/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/',
			'add item'=> '/Order/OrderItems/add/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/',
			'add shipment'=>array('link'=>'/Order/shipments/add/' . $atim_menu_variables['Order.id'] . '/', 'icon' => 'create_shipment'),
		)
	);
	
	$structure_links['index'] = array(
		'aliquot details' => array(
				'link' => '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/',
				'icon' => 'aliquot'),
		'delete' => '/Order/OrderItems/delete/%%OrderLine.order_id%%/%%OrderLine.id%%/%%OrderItem.id%%/');
	
	$structure_override = array();
	$structure_override['OrderItem.shipment_id'] = $order_shipment_list;
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links, 'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>
