<?php 
	
	$structure_links = array(
		'top' => '/inventorymanagement/collections/search',
		'bottom' => array('add' => '/inventorymanagement/collections/add')
	);
	
	$structure_override = array();
	
	$bank_list = array();
	foreach($banks as $new_bank) {
		$bank_list[$new_bank['Bank']['id']] = $new_bank['Bank']['name'];
	}
	$structure_override['Collection.bank_id'] = $bank_list;
	
	$structures->build($atim_structure, array('type' => 'search', 'links' => $structure_links, 'override' => $structure_override));	
	
?>