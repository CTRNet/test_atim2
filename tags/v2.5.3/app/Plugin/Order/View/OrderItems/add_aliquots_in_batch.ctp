<?php
	
	// 1- ALIQUOTS LIST	
	
	$structure_override = array();
		
	$extras = array();
	$final_atim_structure = $atim_structure_for_aliquots_list;
	$final_options = array(
		'type' => 'index', 
		'data' => $aliquots_data, 
		'settings' => array('actions' => false, 'pagination' => false, 'header' => __('add aliquots to order: studied aliquots', null)), 
		'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook('aliquots');
	if($hook_link){
		require($hook_link);
	}

	// BUILD FORM
	$this->Structures->build($final_atim_structure, $final_options);

	
	//2- ORDER ITEMS DATA ENTRY
	
	$extras = $this->Form->input('0.aliquot_ids_to_add', array('type' => 'hidden', 'value' => $aliquot_ids_to_add))
		.$this->Form->input('url_to_cancel', array('type' => 'hidden', 'value' => $url_to_cancel));
	
	$final_atim_structure = $atim_structure_orderitems_data;
	$final_options = array(
		'type' => 'add', 
		'extras' => $extras,
		'data' => $this->request->data,
		'links' => array('top' => '/Order/OrderItems/addAliquotsInBatch/'), 
		'settings' => array('actions' => false, 'header' => __('1- add order data', null), 'form_top' => true, 'form_bottom' => false));
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook('order_item');
	if($hook_link){
		require($hook_link);
	}

	// BUILD FORM
	$this->Structures->build($final_atim_structure, $final_options);
		
	
	// 3- ORDER LINES SELECTION

	$structure_links = array(
		'radiolist'=>array('OrderItem.order_line_id'=>'%%OrderLine.id%%'),
		'bottom' => array('cancel' => $url_to_cancel),
		'top' => '/Order/OrderItems/addAliquotsInBatch/'
	);
		
	$hook_link = $this->Structures->hook('order_lines');	
	$orders_counter = sizeof($order_line_data);
	$first_order = true;
	foreach($order_line_data as $new_order_set) {
		$orders_counter--;
		
		$structure_settings = array(
			'pagination'	=> false,
			'form_inputs'	=> false,
			'form_top'		=> false,
			'form_bottom'	=> $orders_counter? false : true,
			'actions'		=> $orders_counter? false : true,
			'header' => $first_order? __('2- select order line', null) : null, 
			'language_heading' => __('order') . ' : ' . $new_order_set['order']['order_number']
		);
		
		$final_options = array( 'type'=>'index', 'settings'=>$structure_settings, 'data'=>$new_order_set['lines'], 'links'=>$structure_links );
		$final_atim_structure = $atim_structure;
		
		if( $hook_link ) { require($hook_link); }
		
		$this->Structures->build( $final_atim_structure, $final_options );
		
		$first_order = false;
	}
	
?>