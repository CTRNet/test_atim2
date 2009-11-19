<?php
	$structure_settings = array(
		'tree'=>array(
			'Order'		=> 'Order',
			'OrderLine'	=> 'OrderLine'
		),		
//		'columns' => array(
//			1	=> array('width' => '30%'),
//			10	=> array('width' => '70%')
//		)
	);
	
	$structure_links = array(
		'tree'=>array(
			'OrderLine' => array(
				'add' => '/order/order_items/addInBatch/%%Order.id%%/%%OrderLine.id%%/'
			),
		),
	);
	
	$structures->build($atim_structure, array('type' => 'tree', 'settings'=>$structure_settings, 'links'=>$structure_links));
	
?>