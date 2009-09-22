<?php 

	// DISPLAY COLLETCION SEARCH TYPE FORM
	
	$structure_override = array();
	$structure_override['Generated.collection_search_type'] = __('sample', TRUE);
	
	$structures->build($atim_structure_for_search_type, array('type' => 'detail', 'settings' => array('actions' => FALSE), 'override' => $structure_override) );
	
	// DISPLAY COLLETCION INDEX FORM	
	
	$structure_links = array(
		'index' => array('detail' => '/inventorymanagement/sample_masters/detail/%%Collection.id%%'),
		'bottom' => array('add collection' => '/inventorymanagement/collections/add', 'search' => '/inventorymanagement/sample_masters/index')
	);
	
	$structure_override = array();

	$bank_list = array();
	foreach($banks as $new_bank) {
		$bank_list[$new_bank['Bank']['id']] = $new_bank['Bank']['name'];
	}
	$structure_override['Collection.bank_id'] = $bank_list;
		
	$structures->build($atim_structure, array('type' => 'index', 'links' => $structure_links, 'override' => $structure_override));
	
?>
