<?php 
	
	$structure_links = array(
		'index' => array('detail' => '/inventorymanagement/collections/detail/%%Collection.id%%'),
		'bottom' => array('add' => '/inventorymanagement/collections/add', 'search' => '/inventorymanagement/collections/index')
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
