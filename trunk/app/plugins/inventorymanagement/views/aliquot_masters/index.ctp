<?php 

	// DISPLAY COLLETCION SEARCH TYPE FORM
	
	$structure_override = array();
	$structure_override['Generated.collection_search_type'] = __('aliquot', TRUE);
	
	$structures->build($atim_structure_for_search_type, array('type' => 'detail', 'settings' => array('actions' => FALSE), 'override' => $structure_override));
	
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
	
	$structures->build($atim_structure, array('type' => 'search', 'links' => $structure_links, 'override' => $structure_override));	
	
?>