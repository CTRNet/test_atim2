<?php
	
	// Set links
	$structure_links = array('index' => array(), 'bottom' => array());
		
	if($is_inventory_plugin_form){
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
		
		$structure_links['bottom']['add uses'] = array("link" => '/inventorymanagement/aliquot_masters/addAliquotInternalUse/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'], "icon" => "use");
		
		$structure_links['bottom']['realiquoting'] = array(
			'realiquot' =>  array("link" => '/inventorymanagement/aliquot_masters/realiquotInit/creation/' . $atim_menu_variables['AliquotMaster.id'], "icon" => "aliquot"),
			'define realiquoted children' => array("link" => '/inventorymanagement/aliquot_masters/realiquotInit/definition/' . $atim_menu_variables['AliquotMaster.id'], "icon" => "aliquot"));

		$structure_links['bottom']['delete'] = '/inventorymanagement/aliquot_masters/delete/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'];
	}
	
	if($is_tree_view_detail_form) {
		// Detail form displayed in tree view
	} else {
		// General detail form display
		$search_type_links = array();
		$search_type_links['collections'] = array('link'=> '/inventorymanagement/collections/index/', 'icon' => 'search');
		$search_type_links['samples'] = array('link'=> '/inventorymanagement/sample_masters/index/', 'icon' => 'search');
		$search_type_links['aliquots'] = array('link'=> '/inventorymanagement/aliquot_masters/index/', 'icon' => 'search');
		
		$structure_links['bottom']['new search'] = $search_type_links;
	}
	
	// Set override
	
	$structure_override = array();

	if($is_tree_view_detail_form){
		
		// DISPLAY ONLY ALIQUOT DETAIL FORM
		
		// 1- ALIQUOT DETAIL	
		
		$final_atim_structure = $atim_structure;
		$final_options = array('links'=>$structure_links, 'override' => $structure_override, 'data' => $aliquot_master_data, 'settings' => array('header' => __('Aliquot', null)));

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
		
		$final_atim_structure = $atim_structure;
		$final_options = array('override' => $structure_override, 'settings' => array('actions' => false), 'data' => $aliquot_master_data);
		
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
		
		$final_atim_structure = $aliquots_uses_structure;
		$final_options = array('data' => $aliquots_uses_data, 'type' => 'index', 'links'=>$structure_links, 'override' => $structure_override, 'settings' => array('header' => __('uses', null), 'actions' => false));

		// CUSTOM CODE
		$hook_link = $structures->hook('uses');
		if($hook_link){
			require($hook_link); 
		}
		
		// BUILD FORM
		$structures->build($final_atim_structure, $final_options);

		// 3- STORAGE HISTORY	
		
		unset($structure_links['index']);
		$final_atim_structure = $custom_aliquot_storage_history;
		$final_options = array('data' => $storage_data, 'type' => 'index', 'links'=>$structure_links, 'settings' => array('header' => __('storage history', null), 'pagination' => false));
		
		$hook_link = $structures->hook('storage_history');
		if($hook_link){
			require($hook_link);
		}
		
		$structures->build($final_atim_structure, $final_options);
	}
	
?>