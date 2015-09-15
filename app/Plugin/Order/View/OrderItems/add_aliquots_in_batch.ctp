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
	
	$hook_link = $this->Structures->hook('order_lines');	
	
	$header = '2 - '.str_replace('%%order_objects%%', implode(' '.__('or').' ', array(__('order'), __('order line'))), __('%%order_objects%% selection', null));
	while($new_order_data_set = array_shift($order_and_order_line_data)) {
		//Display Order Title
		$language_heading = __('order') . ' : ' . $new_order_data_set['order']['Order']['order_number'];
		//Display Order Selection (if allowed)
		$last_list = empty($order_and_order_line_data) && empty($new_order_data_set['lines']);
		if($item_to_order_direct_link_allowed) {
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
			
			$final_options = array( 'type'=>'index', 'settings'=>$structure_settings, 'data'=>array($new_order_data_set['order']), 'links'=>$structure_links );
			$final_atim_structure = $atim_structure_order;
			$hook_link = $this->Structures->hook('order_item');
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
			if( $hook_link ) { 
				require($hook_link); 
			}
			$this->Structures->build( $final_atim_structure, $final_options );
		}
		$language_heading = null;
	}
	
?>