<?php

	
	
	$structure_links = array();
	if($is_inventory_plugin_form){
		$structure_links['bottom'] =array(
			'edit' => '/inventorymanagement/aliquot_masters/edit/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'], 
			'delete' => '/inventorymanagement/aliquot_masters/delete/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'], 
		);
		if(!empty($aliquot_storage_data)) {
			$structure_links['bottom']['remove from storage'] = '/inventorymanagement/aliquot_masters/removeAliquotFromStorage/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'];
			$structure_links['bottom']['plugin storagelayout access to storage'] = '/storagelayout/storage_masters/detail/' . $aliquot_storage_data['StorageMaster']['id'];
		}
	}

	if(isset($order_line_id) && isset($order_id)){
		$structure_links['bottom']['access order'] = '/order/order_items/listall/'.$order_id.'/'.$order_line_id.'/';
	}else{
		$structure_links['bottom']['add to order'] = '/inventorymanagement/aliquot_masters/addToOrder/'.$atim_menu_variables['AliquotMaster.id'].'/';
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
		
		$structure_links['index'] = array(
		   'edit' => '/inventorymanagement/aliquot_masters/editAliquotUse/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/%%AliquotUse.id%%',
			'delete' => '/inventorymanagement/aliquot_masters/deleteAliquotUse/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/%%AliquotUse.id%%'
		);
		$structure_links['bottom']['add uses'] = array('add internal use' => '/inventorymanagement/aliquot_masters/addAliquotUse/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'] . '/internal use',
											'define realiquoted children' => '/inventorymanagement/aliquot_masters/defineRealiquotedChildren/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id']);
	
	
		$structure_links['bottom']['new search type'] = $search_type_links;
	}

	$structure_override = array();

	$structure_override['AliquotMaster.sop_master_id'] = $arr_aliquot_sops;		
		
	$studies_list = array();
	foreach($arr_studies as $new_study) {
		$studies_list[$new_study['StudySummary']['id']] = $new_study['StudySummary']['title'];
	}	
	$structure_override['AliquotMaster.study_summary_id'] = $studies_list;	

	$blocks_list = array();
	pr('to test block');
	foreach($arr_sample_blocks as $new_block) {
		// TODO test
	}	
	$structure_override['AliquotDetail.block_aliquot_master_id'] = $blocks_list;	

	$gel_matrices_list = array();
	pr('to test matrix');
	foreach($arr_sample_gel_matrices as $new_matrix) {
		// TODO test
	}	
	$structure_override['AliquotDetail.gel_matrix_aliquot_master_id'] = $gel_matrices_list;	

	$final_atim_structure = $atim_structure;
	
	if($is_tree_view_detail_form){
		$final_options = array('links'=>$structure_links, 'override' => $structure_override);

		$hook_link = $structures->hook();
		if($hook_link){
			require($hook_link);
		}

		$structures->build($final_atim_structure, $final_options);
	}else{
		$final_options = array('links'=>$structure_links, 'override' => $structure_override, 'settings' => array('actions' => false));
		$structures->build($final_atim_structure, $final_options);
		
		$final_atim_structure = $aliquots_uses_structure;
		$final_options = array('data' => $aliquots_uses_data, 'type' => 'index', 'links'=>$structure_links, 'settings' => array('header' => __('uses', null)));

		$hook_link = $structures->hook('uses');
		if($hook_link){
			require($hook_link); 
		
		}
		$structures->build($final_atim_structure, $final_options);
	}
	
	
	$final_atim_structure = ; 
	$final_options = ;
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	

	
?>