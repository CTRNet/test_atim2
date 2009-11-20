<?php
	$structure_settings = array(
		'tree'=>array(
			'Order'		=> 'Order',
			'OrderLine'	=> 'OrderLine'
		),		
	);
	$structure_links = array(
		'tree'=>array(
			'OrderLine' => array(
				'add' => '/order/order_items/add/%%OrderLine.order_id%%/%%OrderLine.id%%/'.$aliquot_master_id.'/'
			),
		),
	);
	
	$structures->build($atim_structure, array('type' => 'tree', 'settings'=>$structure_settings, 'links'=>$structure_links));
	
?>