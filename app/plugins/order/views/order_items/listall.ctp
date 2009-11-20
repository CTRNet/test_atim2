<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit' => '/order/order_items/edit/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/',
			'add'=>'/order/order_items/add/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/',
		)
	);
	
	if(isset($status_pending)){
		$structure_links['index'] = array(
			'delete' => '/order/order_items/delete/%%OrderLine.order_id%%/%%OrderLine.id%%/%%OrderItem.id%%/',
			'go to' => '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/');
	}
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>
