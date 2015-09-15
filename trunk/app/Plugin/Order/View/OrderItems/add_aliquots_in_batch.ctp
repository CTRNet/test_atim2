<?php
	
	// 1- ALIQUOTS LIST	
	
	$structure_override = array();
		
	$extras = array();
	$final_atim_structure = $atim_structure_for_aliquots_list;
	$final_options = array(
		'type' => 'index', 
		'data' => $aliquots_data, 
		'settings' => array('actions' => false, 'pagination' => false, 'header' => array('title' => __('add aliquots to order'), 'description' => __('studied aliquots'))), 
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
		'settings' => array('actions' => false, 'header' =>'1 - '. __('order item data'), 'form_top' => true, 'form_bottom' => false));
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook('order_item');
	if($hook_link){
		require($hook_link);
	}

	// BUILD FORM
	$this->Structures->build($final_atim_structure, $final_options);
		
	
	// 3- ORDER OR ORDER LINES SELECTION

	$structure_links = array(
		'radiolist'=>array('FunctionManagement.selected_order_and_order_line_ids'=>'%%Generated.order_and_order_line_ids%%'),
		'bottom' => array('cancel' => $url_to_cancel),
		'top' => '/Order/OrderItems/addAliquotsInBatch/'
	);
	
	$linked_objects = array();
	if(Configure::read('order_item_to_order_objetcs_link_setting') != 2) $linked_objects[] = __('order');
	if(Configure::read('order_item_to_order_objetcs_link_setting') != 3) $linked_objects[] = __('order line');
	$header = '2 - '.str_replace('%%order_objects%%', implode(' '.__('or').' ', $linked_objects), __('%%order_objects%% selection', null));
	if(Configure::read('order_item_to_order_objetcs_link_setting') == 3) {
		//Merge all orders in one array() then reset $order_and_order_line_data
		$tmp_all_orders = array();
		foreach($order_and_order_line_data as $new_data_to_merge) {
			$tmp_all_orders[] = $new_data_to_merge['order'][0];
		}
		$order_and_order_line_data = array(array('order' => $tmp_all_orders, 'lines' => array()));
	}
	
	$hook_link = $this->Structures->hook('order_and_order_lines');	
	
	while($new_order_data_set = array_shift($order_and_order_line_data)) {
		//Display Order Title
		$language_heading = __('order') . ' : ' . $new_order_data_set['order'][0]['Order']['order_number'];
		if(Configure::read('order_item_to_order_objetcs_link_setting') == 3) $language_heading = null;
		//Display Order Selection (if allowed)
		$last_list = empty($order_and_order_line_data) && empty($new_order_data_set['lines']);
		if($item_to_order_direct_link_allowed && Configure::read('order_item_to_order_objetcs_link_setting') != 2) {
			//Item can be directly linked to an order
			$structure_settings = array(
				'pagination'	=> false,
				'form_inputs'	=> false,
				'form_top'		=> false,
				'form_bottom'	=> $last_list? true : false,
				'actions'		=> $last_list? true : false,
				'header' => $header,
				'language_heading' => $language_heading
			);
			
			$final_options = array( 'type'=>'index', 'settings'=>$structure_settings, 'data'=>$new_order_data_set['order'], 'links'=>$structure_links );
			$final_atim_structure = $atim_structure_order;
			$hook_link = $this->Structures->hook('orders');
			if( $hook_link ) { 
				require($hook_link); 
			}
			$this->Structures->build( $final_atim_structure, $final_options );
			$header = null;
			$language_heading = null;
		}
		//Display Order Line Selection
		if($new_order_data_set['lines']) {
			$last_list = empty($order_and_order_line_data);
			$structure_settings = array(
				'pagination'	=> false,
				'form_inputs'	=> false,
				'form_top'		=> false,
				'form_bottom'	=>$last_list? true : false,
				'actions'		=>$last_list? true : false,
				'header' => $header,
				'language_heading' => $language_heading
			);
			$final_options = array( 'type'=>'index', 'settings'=>$structure_settings, 'data'=>$new_order_data_set['lines'], 'links'=>$structure_links );
			$final_atim_structure = $atim_structure_order_line;
			$hook_link = $this->Structures->hook('order_lines');
			if( $hook_link ) { 
				require($hook_link); 
			}
			$this->Structures->build( $final_atim_structure, $final_options );
		}
		$header = null;
		$language_heading = null;
	}
	
?>