<?php 

	// DISPLAY COLLETCION SEARCH TYPE FORM
	
	$structure_override = array();
	$structure_override['Generated.collection_search_type'] = __('aliquot', TRUE);
	
	$final_atim_structure = $atim_structure_for_search_type; 
	$final_options = array('type' => 'detail', 'settings' => array('actions' => FALSE), 'override' => $structure_override);
	
	// custom code
	$hook_link = $structures->hook('search_type');
	if( $hook_link ) { require($hook_link); }
		
	// build form
	$structures->build( $final_atim_structure, $final_options );
	
	
	// DISPLAY COLLETCION INDEX FORM	

	$search_type_links = array();
	$search_type_links['collection'] = '/inventorymanagement/collections/index/';
	$search_type_links['sample'] = '/inventorymanagement/sample_masters/index/';
	$search_type_links['aliquot'] = '/inventorymanagement/aliquot_masters/index/';
		
	$structure_links = array(
		'top' => '/inventorymanagement/aliquot_masters/search',
		'bottom' => array('add collection' => '/inventorymanagement/collections/add', 'search' => $search_type_links)
	);

	$structure_override = array();
		
	$bank_list = array();
	foreach($banks as $new_bank) {
		$bank_list[$new_bank['Bank']['id']] = $new_bank['Bank']['name'];
	}
	$structure_override['Collection.bank_id'] = $bank_list;
	
	$hook_link = $structures->hook();
	if($hook_link){
		require($hook_link); 
	}
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'search', 'links' => $structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	

	
?>