<?php 

	$structure_links = array();
	if($is_inventory_plugin_form){
		$structure_links['bottom'] = array(
			'edit' => '/inventorymanagement/collections/edit/' . $atim_menu_variables['Collection.id'], 
			'delete' => '/inventorymanagement/collections/delete/' . $atim_menu_variables['Collection.id']
		);
	}
		
	if($is_tree_view_detail_form){
		// Detail form displayed in tree view: Add button to access all sample data
		$structure_links['bottom']['access to all data'] = '/inventorymanagement/collections/detail/' . $atim_menu_variables['Collection.id'] . '/';
	}else{
		// General detail form display
		$search_type_links = array();
		$search_type_links['collection'] = '/inventorymanagement/collections/index/';
		$search_type_links['sample'] = '/inventorymanagement/sample_masters/index/';
		$search_type_links['aliquot'] = '/inventorymanagement/aliquot_masters/index/';
	
		$structure_links['bottom']['search'] = $search_type_links;
	}
	
	$structure_override = array();
	
	$bank_list = array();
	foreach($banks as $new_bank) {
		$bank_list[$new_bank['Bank']['id']] = $new_bank['Bank']['name'];
	}
	$structure_override['Collection.bank_id'] = $bank_list;
	
	$structure_override['Collection.sop_master_id'] = $arr_collection_sops;	

	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
	
?>