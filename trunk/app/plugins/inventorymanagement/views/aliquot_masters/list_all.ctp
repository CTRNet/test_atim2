<?php 

	$sample_master_id = array_key_exists('SampleMaster.id', $atim_menu_variables)? $atim_menu_variables['SampleMaster.id']: '-1';
		
	// Manage filter button
	$main_link = '/inventorymanagement/aliquot_masters/listAll/' . $atim_menu_variables['Collection.id'] . '/' . $sample_master_id;
		
	$filter_links = array();
	foreach ($existing_sample_aliquot_types as $controls_key => $sample_aliquot_type_data) {
		$filter_key = __($sample_aliquot_type_data['sample_type'], TRUE) . ' ' . __($sample_aliquot_type_data['aliquot_type'], TRUE);
		$filter_links[$filter_key] = $main_link . '/' . $controls_key;
	}	
	$filter_links['no filter'] = $main_link . '/-1';
	$filter_links = (sizeof($filter_links) == 1)? '/underdevelopment/': $filter_links;

	// Manage search button	
	$search_type_links = array();
	$search_type_links['collection'] = '/inventorymanagement/collections/index/';
	$search_type_links['sample'] = '/inventorymanagement/sample_masters/index/';
	$search_type_links['aliquot'] = '/inventorymanagement/aliquot_masters/index/';
	
	$structure_links = array(
		'index' => array(
			'detail' => '/inventorymanagement/sample_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%'
		),
		'bottom' => array(
			'filter' => $filter_links,
			'search' => $search_type_links
		)
	);

	$structure_override = array();
	
	$structures->build($atim_structure, array('type' => 'index', 'links' => $structure_links, 'override' => $structure_override));	

?>