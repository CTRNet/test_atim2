<?php
	$settings = array();
		
	// Set links
	$structure_links = array('index' => array(), 'bottom' => array());
		
	$structure_links['bottom']['edit'] = '/InventoryManagement/AliquotMasters/edit/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'];
	$structure_links['bottom']['delete'] = '/InventoryManagement/AliquotMasters/delete/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'];
	$structure_links['bottom']['storage'] = '/underdevelopment/';
	if(!empty($aliquot_storage_data)) {
		$structure_links['bottom']['storage'] = array(
			'plugin storagelayout access to storage' => array("link" => '/StorageLayout/StorageMasters/detail/' . $aliquot_storage_data['StorageMaster']['id'], "icon" => "storage"),
			'remove from storage' => array("link" => '/InventoryManagement/AliquotMasters/removeAliquotFromStorage/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'], "icon" => "storage"));
	}
	
	if(isset($order_line_id) && isset($order_id)){
		$structure_links['bottom']['access to order'] = array("link" => '/Order/OrderItems/listall/'.$order_id.'/'.$order_line_id.'/', "icon" => "order");
	}else{
		$structure_links['bottom']['add to order'] = array("link" => '/Order/OrderItems/addAliquotsInBatch/'.$atim_menu_variables['AliquotMaster.id'].'/', "icon" => "order");
	}		
	
	$structure_links['bottom']['add uses'] = array("link" => '/InventoryManagement/AliquotMasters/addAliquotInternalUse/'. $atim_menu_variables['AliquotMaster.id'], "icon" => "use");
	
	$structure_links['bottom']['realiquoting'] = array(
		'realiquot' =>  array("link" => '/InventoryManagement/AliquotMasters/realiquotInit/creation/' . $atim_menu_variables['AliquotMaster.id'], "icon" => "aliquot"),
		'define realiquoted children' => array("link" => '/InventoryManagement/AliquotMasters/realiquotInit/definition/' . $atim_menu_variables['AliquotMaster.id'], "icon" => "aliquot"));

	$structure_links['bottom']['create derivative'] = $can_create_derivative ? '/InventoryManagement/SampleMasters/batchDerivativeInit/'.$atim_menu_variables['AliquotMaster.id'] : 'cannot';
	

	if($is_from_tree_view_or_layout == 1) {
		// Tree view
		$settings['header'] = __('aliquot', null);
		
	} else if($is_from_tree_view_or_layout == 2) {
		// Storage Layout
		$structure_links = array();
		$structure_links['bottom']['access to all data'] = '/InventoryManagement/AliquotMasters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'];

		$settings['header'] = __('aliquot', null);
		
	} else {
		// General detail form display
//		$structure_links['bottom'] = array_merge( array('new search' => InventoryManagementAppController::$search_links), $structure_links['bottom']); 
	}
	
	$final_atim_structure = $atim_structure;
	if($is_from_tree_view_or_layout){
		// DISPLAY ONLY ALIQUOT DETAIL FORM
		// 1- ALIQUOT DETAIL	
		$final_options = array('links'=>$structure_links, 'data' => $aliquot_master_data, 'settings' => $settings);

		// CUSTOM CODE
		$hook_link = $this->Structures->hook('aliquot_detail_1');
		if($hook_link){
			require($hook_link);
		}

		// BUILD FORM
		$this->Structures->build($final_atim_structure, $final_options);

	}else{
		// DISPLAY BOTH ALIQUOT DETAIL FORM AND ALIQUOT USES LIST
		// 1- ALIQUOT DETAIL	
		$final_options = array(
			'settings' => array('actions' => false), 
			'data' => $aliquot_master_data
		);
		
		// CUSTOM CODE
		$hook_link = $this->Structures->hook('aliquot_detail_2');
		if($hook_link){
			require($hook_link);
		}

		// BUILD FORM
		$this->Structures->build($final_atim_structure, $final_options);
		$data_url = sprintf('InventoryManagement/AliquotMasters/listallUses/%d/%d/%d/', $atim_menu_variables['Collection.id'], $atim_menu_variables['SampleMaster.id'], $atim_menu_variables['AliquotMaster.id']);
		// 2- USES LIST
		$final_atim_structure = $empty_structure;
		$final_options = array(
			'data' => array(), 
			'settings' => array('header' => __('uses'), 'actions' => false),
			'extras'	=> AppController::checkLinkPermission($data_url) ? '<div class="ajaxLoad" data-url="'.$data_url.'"></div>' : '<div>'.__('You are not authorized to access that location.', true).'</div>'
		);

		// CUSTOM CODE
		$hook_link = $this->Structures->hook('uses');
		if($hook_link){
			require($hook_link); 
		}
		
		// BUILD FORM
		$this->Structures->build($final_atim_structure, $final_options);

		// 3- STORAGE HISTORY
		$data_url = sprintf('InventoryManagement/AliquotMasters/storageHistory/%d/%d/%d/', $atim_menu_variables['Collection.id'], $atim_menu_variables['SampleMaster.id'], $atim_menu_variables['AliquotMaster.id']);
		unset($structure_links['index']);
		$final_atim_structure = $empty_structure;
		$final_options = array(
			'links'		=> $structure_links,
			'settings'	=> array('header' => __('storage history'), 'actions' => false),
			'extras'	=> AppController::checkLinkPermission($data_url) ? '<div class="ajaxLoad" data-url="'.$data_url.'"></div>' : '<div>'.__('You are not authorized to access that location.', true).'</div>'
		);
		
		$hook_link = $this->Structures->hook('storage_history');
		if($hook_link){
			require($hook_link);
		}
		
		$this->Structures->build($final_atim_structure, $final_options);

		
		
		// 4 - REALIQUOTED PARENTS	
		$data_url = sprintf('InventoryManagement/AliquotMasters/listAllRealiquotedParents/%d/%d/%d/', $atim_menu_variables['Collection.id'], $atim_menu_variables['SampleMaster.id'], $atim_menu_variables['AliquotMaster.id']);
		unset($structure_links['index']);
		$final_atim_structure = $empty_structure;
		$final_options = array(
			'links'		=> $structure_links,
			'settings'	=> array('header' => __('realiquoted parent')),
			'extras'	=> AppController::checkLinkPermission($data_url) ? '<div class="ajaxLoad" data-url="'.$data_url.'"></div>' : '<div>'.__('You are not authorized to access that location.', true).'</div>'
		);
		
		$hook_link = $this->Structures->hook('realiquoted_parent');
		if($hook_link){
			require($hook_link);
		}
		
		$this->Structures->build($final_atim_structure, $final_options);
	}
