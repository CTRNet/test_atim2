<?php 
	
	$filter_links = array();
	$main_link = '/inventorymanagement/sample_masters/listAll/' . $atim_menu_variables['Collection.id'];
	$filter_links['specimen'] = $main_link . '/CATEGORY|specimen';
	foreach ($specimen_sample_type_list as $type => $sample_control_id) {
		$filter_links[$type] = $main_link . '/SAMP_TYPE|' . $sample_control_id;
	}
	$filter_links['derivative'] = $main_link . '/CATEGORY|derivative';
	foreach ($derivative_sample_type_list as $type => $sample_control_id) {
		$filter_links[$type] = $main_link . '/SAMP_TYPE|' . $sample_control_id;
	}
	$filter_links['no filter'] = $main_link .  '/-1';	
	
	$add_links = array();
	foreach ($specimen_sample_controls_list as $sample_control) {
		$add_links[$sample_control['SampleControl']['sample_type']] = '/inventorymanagement/sample_masters/add/' . $atim_menu_variables['Collection.id'] . '/' . $sample_control['SampleControl']['id'];
	}
	
	$search_type_links = array();
	$search_type_links['collection'] = '/inventorymanagement/collections/index/';
	$search_type_links['sample'] = '/inventorymanagement/sample_masters/index/';
	$search_type_links['aliquot'] = '/underdevelopment/';

	if($is_derivatives_list) {
		$add_links = '/underdevelopment/';
		$filter_links = '/underdevelopment/';
	}

	$structure_links = array(
		'index' => array( 
			'detail' => '/inventorymanagement/sample_masters/detail/' . $atim_menu_variables['Collection.id'] . '/%%SampleMaster.id%%'
		),
		'bottom' => array(
			'add' => $add_links,
			'filter' => $filter_links,
			'search' => $search_type_links
		)
	);

	$structure_override = array();
	
	$structures->build($atim_structure, array('type'=>'index', 'links' => $structure_links, 'override' => $structure_override));	

?>