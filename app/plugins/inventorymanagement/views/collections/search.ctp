<?php 

	$search_type_links = array();
	$search_type_links['collections'] = '/inventorymanagement/collections/index/';
	$search_type_links['samples'] = '/inventorymanagement/sample_masters/index/';
	$search_type_links['aliquots'] = '/inventorymanagement/aliquot_masters/index/';
	
	$structure_links = array(
		'index' => array('detail' => '/inventorymanagement/collections/detail/%%Collection.id%%'),
		'bottom' => array('add collection' => '/inventorymanagement/collections/add', 'new search' => $search_type_links['collections'], 'new search type' => $search_type_links)
	);
	
	$structure_override = array();
	
	$bank_list = array();
	foreach($banks as $new_bank) {
		$bank_list[$new_bank['Bank']['id']] = $new_bank['Bank']['name'];
	}
	$structure_override['Collection.bank_id'] = $bank_list;
	
	$structure_override['Collection.sop_master_id'] = $arr_collection_sops;
	
	$final_atim_structure = $atim_structure;
	$final_options = array('type' => 'index', 'data' => $collections_data, 'links' => $structure_links, 'override' => $structure_override, 'settings' => array('header' => __('search type', null).': '.__('collections', null)));
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
				
?>
