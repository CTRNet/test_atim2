<?php

	// 1- ALIQUOTS LIST	
	
	$structure_override = array();
			
	$final_atim_structure = $atim_structure_for_aliquots_list;
	$final_options = array(
		'type' => 'index', 
		'data' => $aliquots_data, 
		'settings' => array('actions' => false, 'header' => __('add aliquots to order: studied aliquots', null)), 
		'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook('aliquots');
	if($hook_link){
		require($hook_link);
	}

	// BUILD FORM
	$structures->build($final_atim_structure, $final_options);

	
	//2- ORDER ITEMS DATA ENTRY
	
	$final_atim_structure = $atim_structure_orderitems_data;
	$final_options = array(
		'type' => 'add', 
		'links' => array('top' => '/order/order_items/addAliquotsInBatch/'), 
		'settings' => array('actions' => false, 'header' => __('1- add order data', null), 'separator' => true, 'form_top' => true, 'form_bottom' => false));
	
	// CUSTOM CODE
	$hook_link = $structures->hook('order_item');
	if($hook_link){
		require($hook_link);
	}

	// BUILD FORM
	$structures->build($final_atim_structure, $final_options);
	echo("</form>");
	
	
	// 3- ORDER LINES SELECTION

	$structure_settings = array(
		'header' => __('2- select order line', null), 
		'separator' => true, 
		'pagination'=>false, 
		'form_top'=>false, 
		'form_inputs'=>false, 
	);
	
	$structure_links = array(
		'radiolist'=>array('OrderLine.id'=>'%%OrderLine.id%%'),
		'bottom' => array('cancel' => $url_to_cancel),
		'top' => '/order/order_items/addAliquotsInBatch/'
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'radiolist', 
		'data' => $order_line_data,
		'links'=> $structure_links, 
		'settings'=> $structure_settings, 
		'override'=>$structure_override);
	
	// CUSTOM CODE
		$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>