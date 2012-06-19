<?php
	$settings = array();
		
	// Set links
	$structure_links = array('index' => array(), 'bottom' => array());
		
	$structure_links['bottom']['edit'] = '/inventorymanagement/aliquot_masters/edit/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'];
	
	$structure_links['bottom']['storage'] = '/underdevelopment/';
	if(!empty($aliquot_storage_data)) {
		$structure_links['bottom']['storage'] = array(
			'plugin storagelayout access to storage' => array("link" => '/storagelayout/storage_masters/detail/' . $aliquot_storage_data['StorageMaster']['id'], "icon" => "storage"),
			'remove from storage' => array("link" => '/inventorymanagement/aliquot_masters/removeAliquotFromStorage/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'], "icon" => "storage"));
	}
	
	if(isset($order_line_id) && isset($order_id)){
		$structure_links['bottom']['access to order'] = array("link" => '/order/order_items/listall/'.$order_id.'/'.$order_line_id.'/', "icon" => "order");
	}else{
		$structure_links['bottom']['add to order'] = array("link" => '/order/order_items/addAliquotsInBatch/'.$atim_menu_variables['AliquotMaster.id'].'/', "icon" => "order");
	}		
	
	$structure_links['bottom']['add uses'] = array("link" => '/inventorymanagement/aliquot_masters/addAliquotInternalUse/'. $atim_menu_variables['AliquotMaster.id'], "icon" => "use");
	
	$structure_links['bottom']['realiquoting'] = array(
		'realiquot' =>  array("link" => '/inventorymanagement/aliquot_masters/realiquotInit/creation/' . $atim_menu_variables['AliquotMaster.id'], "icon" => "aliquot"),
		'define realiquoted children' => array("link" => '/inventorymanagement/aliquot_masters/realiquotInit/definition/' . $atim_menu_variables['AliquotMaster.id'], "icon" => "aliquot"));

	$structure_links['bottom']['create derivative'] = $can_create_derivative ? '/inventorymanagement/sample_masters/batchDerivativeInit/'.$atim_menu_variables['AliquotMaster.id'] : 'cannot';
	$structure_links['bottom']['delete'] = '/inventorymanagement/aliquot_masters/delete/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'];

	if($is_from_tree_view_or_layout == 1) {
		// Tree view
		$settings['header'] = __('aliquot', null);
		
	} else if($is_from_tree_view_or_layout == 2) {
		// Storage Layout
		$structure_links = array();
		$structure_links['bottom']['access to all data'] = '/inventorymanagement/aliquot_masters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'];

		$settings['header'] = __('aliquot', null);
		
	} else {
		// General detail form display
//		$structure_links['bottom'] = array_merge( array('new search' => InventorymanagementAppController::$search_links), $structure_links['bottom']); 
	}
	
	$final_atim_structure = $atim_structure;
	if($is_from_tree_view_or_layout){
		// DISPLAY ONLY ALIQUOT DETAIL FORM
		// 1- ALIQUOT DETAIL	
		$final_options = array('links'=>$structure_links, 'data' => $aliquot_master_data, 'settings' => $settings);

		// CUSTOM CODE
		$hook_link = $structures->hook('aliquot_detail_1');
		if($hook_link){
			require($hook_link);
		}

		// BUILD FORM
		$structures->build($final_atim_structure, $final_options);

	}else{
		// DISPLAY BOTH ALIQUOT DETAIL FORM AND ALIQUOT USES LIST
		// 1- ALIQUOT DETAIL	
		$final_options = array(
			'settings' => array('actions' => false), 
			'data' => $aliquot_master_data
		);
		
		// CUSTOM CODE
		$hook_link = $structures->hook('aliquot_detail_2');
		if($hook_link){
			require($hook_link);
		}

		// BUILD FORM
		$structures->build($final_atim_structure, $final_options);
		
		// 2- USES LIST
		$structure_links['index'] = array(
		   'detail' => '/inventorymanagement/aliquot_masters/redirectToAliquotUseDetail/%%ViewAliquotUse.detail_url%%');
		
		$final_atim_structure = $empty_structure;
		$final_options = array(
			'data' => array(), 
			'settings' => array('header' => __('uses', null), 'actions' => false),
			'extras'	=> '<div class="uses"><div class="loading">---'.__('loading', true).'---</div></div>'
		);

		// CUSTOM CODE
		$hook_link = $structures->hook('uses');
		if($hook_link){
			require($hook_link); 
		}
		
		// BUILD FORM
		$structures->build($final_atim_structure, $final_options);

		// 3- STORAGE HISTORY	
		unset($structure_links['index']);
		$final_atim_structure = $empty_structure;
		$final_options = array(
			'links'		=> $structure_links,
			'settings'	=> array('header' => __('storage history', null)),
			'extras'	=> '<div class="storage_history"><div class="loading">---'.__('loading', true).'---</div></div>'
		);
		
		$hook_link = $structures->hook('storage_history');
		if($hook_link){
			require($hook_link);
		}
		
		$structures->build($final_atim_structure, $final_options);
	}
	
?>