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
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'tree', 'settings'=>$structure_settings, 'links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
?>