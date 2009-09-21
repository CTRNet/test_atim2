<?php 

	// DISPLAY COLLETCION SEARCH TYPE FORM
	
	$structure_override = array();
	$structure_override['Generated.collection_search_type'] = __('collection', TRUE);
	
	$structures->build($atim_structure_for_search_type, array('type' => 'detail', 'settings' => array('actions' => FALSE), 'override' => $structure_override) );
	
	// DISPLAY COLLETCION INDEX FORM	
	
	$structure_links = array(
		'index' => array('detail' => '/inventorymanagement/collections/detail/%%Collection.id%%'),
		'bottom' => array('add collection' => '/inventorymanagement/collections/add', 'search' => '/inventorymanagement/collections/index')
	);
	
	$structure_override = array();
	
	$bank_list = array();
	foreach($banks as $new_bank) {
		$bank_list[$new_bank['Bank']['id']] = $new_bank['Bank']['name'];
	}
	$structure_override['Collection.bank_id'] = $bank_list;
	
	$structure_override['Collection.sop_master_id'] = $arr_collection_sops;
	
	$structures->build($atim_structure, array('type' => 'index', 'links' => $structure_links, 'override' => $structure_override));
	
?>
