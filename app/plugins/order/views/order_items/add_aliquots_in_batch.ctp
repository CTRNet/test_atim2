<?php

	// 1- ALIQUOTS LIST	
	
	$structure_override = array();
			
	$final_atim_structure = $atim_structure_for_aliquots_list;
	$final_options = array('override' => $structure_override,  'type' => 'index', 'settings' => array('actions' => false, 'header' => __('selected aliquots for order', null)), 'data' => $aliquots_data);
	
	// CUSTOM CODE
	$hook_link = $structures->hook('aliquots');
	if($hook_link){
		require($hook_link);
	}

	// BUILD FORM
	$structures->build($final_atim_structure, $final_options);


	// 2- ORDER LINES

	$structure_settings = array(
		'tree'=>array(
			'Order'		=> 'Order',
			'OrderLine'	=> 'OrderLine'
		),
		'header' => __('select order line', null), 
		'separator' => true
	);
	
	$structure_links = array(
		'tree'=>array(
			'OrderLine' => array(
				'add' => '/order/order_items/addAliquotsInBatch/-1/%%OrderLine.order_id%%/%%OrderLine.id%%/'
			),
		),
		'bottom' => array('cancel' => $url_to_cancel)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'tree', 'settings'=>$structure_settings, 'links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
	
?>