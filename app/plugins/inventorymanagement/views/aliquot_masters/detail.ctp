<?php
	
	// Set links
	$structure_links = array('index' => array(), 'bottom' => array());
		
	if($is_inventory_plugin_form){
		$structure_links['bottom']['edit'] = '/inventorymanagement/aliquot_masters/edit/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'];
		$structure_links['bottom']['plugin storagelayout access to storage'] = empty($aliquot_storage_data)? '/underdevelopment/': '/storagelayout/storage_masters/detail/' . $aliquot_storage_data['StorageMaster']['id'];
		$structure_links['bottom']['remove from storage'] = empty($aliquot_storage_data)? '/underdevelopment/': '/inventorymanagement/aliquot_masters/removeAliquotFromStorage/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'];
		
		if(isset($order_line_id) && isset($order_id)){
			$structure_links['bottom']['access order'] = '/order/order_items/listall/'.$order_id.'/'.$order_line_id.'/';
		}else{
			$structure_links['bottom']['add to order'] = '/inventorymanagement/aliquot_masters/addToOrder/'.$atim_menu_variables['AliquotMaster.id'].'/';
		}		
		
		$structure_links['bottom']['add uses'] = array(
			'add internal use' => '/inventorymanagement/aliquot_masters/addAliquotUse/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'] . '/internal use',
			'define realiquoted children' => '/inventorymanagement/aliquot_masters/defineRealiquotedChildren/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id']);

		$structure_links['bottom']['delete'] = '/inventorymanagement/aliquot_masters/delete/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'];
	}
	
	if($is_tree_view_detail_form) {
		// Detail form displayed in tree view: Add button to access all aliquot data
		$structure_links['bottom']['access to all data'] = '/inventorymanagement/aliquot_masters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'];
		
	} else {
		// General detail form display
		$search_type_links = array();
		$search_type_links['collections'] = '/inventorymanagement/collections/index/';
		$search_type_links['samples'] = '/inventorymanagement/sample_masters/index/';
		$search_type_links['aliquots'] = '/inventorymanagement/aliquot_masters/index/';
		
		$structure_links['bottom']['new search type'] = $search_type_links;
	}
	
	// Set override
	$structure_override = array();

	$sops_list = array();
	foreach($arr_aliquot_sops as $sop_masters) { $sops_list[$sop_masters['SopMaster']['id']] = $sop_masters['SopMaster']['code']; }
	$structure_override['AliquotMaster.sop_master_id'] = $sops_list; 	
		
	$studies_list = array();
	foreach($arr_studies as $new_study) {
		$studies_list[$new_study['StudySummary']['id']] = $new_study['StudySummary']['title'];
	}	
	$structure_override['AliquotMaster.study_summary_id'] = $studies_list;	

	$blocks_list = array();
	foreach($arr_sample_blocks as $new_block) {
		$blocks_list[$new_block['AliquotMaster']['id']] = $new_block['AliquotMaster']['barcode'];
	}	
	$structure_override['AliquotDetail.block_aliquot_master_id'] = $blocks_list;	

	$gel_matrices_list = array();
	foreach($arr_sample_gel_matrices as $new_matrix) {
		$gel_matrices_list[$new_matrix['AliquotMaster']['id']] = $new_matrix['AliquotMaster']['barcode'];
	}	
	$structure_override['AliquotDetail.gel_matrix_aliquot_master_id'] = $gel_matrices_list;	

	if($is_tree_view_detail_form){
		
		// DISPLAY ONLY ALIQUOT DETAIL FORM
		
		// 1- ALIQUOT DETAIL	
		
		$final_atim_structure = $atim_structure;
		$final_options = array('links'=>$structure_links, 'override' => $structure_override, 'data' => $aliquot_master_data);

		// CUSTOM CODE
		$hook_link = $structures->hook();
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
		$hook_link = $structures->hook();
		if($hook_link){
			require($hook_link);
		}

		// BUILD FORM
		$structures->build($final_atim_structure, $final_options);
		
		// 2- USES LIST
		
		$structure_links['index'] = array(
		   'edit' => '/inventorymanagement/aliquot_masters/editAliquotUse/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/%%AliquotUse.id%%',
			'delete' => '/inventorymanagement/aliquot_masters/deleteAliquotUse/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/%%AliquotUse.id%%'
		);
		
		$final_atim_structure = $aliquots_uses_structure;
		$final_options = array('data' => $aliquots_uses_data, 'type' => 'index', 'links'=>$structure_links, 'settings' => array('header' => __('uses', null)));

		// CUSTOM CODE
		$hook_link = $structures->hook('uses');
		if($hook_link){
			require($hook_link); 
		}
		
		// BUILD FORM
		$structures->build($final_atim_structure, $final_options);
	}
	
?>