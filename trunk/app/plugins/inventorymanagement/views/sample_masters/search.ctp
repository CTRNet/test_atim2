<?php 

	// DISPLAY COLLETCION SEARCH TYPE FORM
	
	$structure_override = array();
	$structure_override['Generated.collection_search_type'] = __('sample', TRUE);
	
	$hook_link = $structures->hook('generated');
	if($hook_link){
		require($hook_link); 
	}
	$structures->build($atim_structure_for_search_type, array('type' => 'detail', 'data' => array(array('Generated' => array('collection_search_type' => null))), 'settings' => array('actions' => FALSE), 'override' => $structure_override));
	
	// DISPLAY COLLETCION INDEX FORM	
	
	$search_type_links = array();
	$search_type_links['collection'] = '/inventorymanagement/collections/index/';
	$search_type_links['sample'] = '/inventorymanagement/sample_masters/index/';
	$search_type_links['aliquot'] = '/inventorymanagement/aliquot_masters/index/';
	
	$structure_links = array(
		'index' => array('detail' => '/inventorymanagement/sample_masters/detail/%%Collection.id%%/%%SampleMaster.id%%'),
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
	$structures->build($atim_structure, array('type' => 'index', 'data' => $this->data, 'links' => $structure_links, 'override' => $structure_override));
	
?>
