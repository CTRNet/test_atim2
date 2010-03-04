<?php 

	$structure_links = array();
	if($is_inventory_plugin_form){
		$add_links = array();
		foreach ($specimen_sample_controls_list as $sample_control) {
			$add_links[$sample_control['SampleControl']['sample_type']] = '/inventorymanagement/sample_masters/add/' . $atim_menu_variables['Collection.id'] . '/' . $sample_control['SampleControl']['id'];
		}
		
		$structure_links['bottom'] = array(
			'edit' => '/inventorymanagement/collections/edit/' . $atim_menu_variables['Collection.id'], 
			'add specimen' => $add_links,
			'delete' => '/inventorymanagement/collections/delete/' . $atim_menu_variables['Collection.id']
		);
	}
		
	if($is_tree_view_detail_form){
		// Detail form displayed in tree view: Add button to access all sample data
		$structure_links['bottom']['access to all data'] = '/inventorymanagement/collections/detail/' . $atim_menu_variables['Collection.id'] . '/';
	}else{
		// General detail form display
		$search_type_links = array();
		$search_type_links['collections'] = '/inventorymanagement/collections/index/';
		$search_type_links['samples'] = '/inventorymanagement/sample_masters/index/';
		$search_type_links['aliquots'] = '/inventorymanagement/aliquot_masters/index/';
	
		$structure_links['bottom']['new search type'] = $search_type_links;
	}
	
	$structure_override = array();
	
	$structure_override['ViewCollection.bank_id'] = $bank_list;
	$structure_override['ViewCollection.sop_master_id'] = $sop_list; 

	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
	
?>