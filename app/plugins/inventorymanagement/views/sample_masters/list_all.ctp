<?php 

	$initial_specimen_sample_id = array_key_exists('SampleMaster.initial_specimen_sample_id', $atim_menu_variables)? $atim_menu_variables['SampleMaster.initial_specimen_sample_id']: '-1';
		
	// Manage add button
	$add_links = array();
	foreach ($specimen_sample_controls_list as $sample_control) {
		$add_links[$sample_control['SampleControl']['sample_type']] = '/inventorymanagement/sample_masters/add/' . $atim_menu_variables['Collection.id'] . '/' . $sample_control['SampleControl']['id'];
	}
	$add_links = empty($add_links)? '/underdevelopment/': $add_links;
	
	// Manage filter button
	$main_link = '/inventorymanagement/sample_masters/listAll/' . $atim_menu_variables['Collection.id'] . '/' . $initial_specimen_sample_id;
		
	$filter_links = array();	
	if(!empty($existing_specimen_sample_types)) {
		$filter_links['specimen'] = $main_link . '/CATEGORY|specimen';
		foreach ($existing_specimen_sample_types as $type => $sample_control_id) {
			$filter_links[$type] = $main_link . '/SAMP_CONT_ID|' . $sample_control_id;
		}
		$filter_links['derivative'] = $main_link . '/CATEGORY|derivative';		
	}
	foreach ($existing_derivative_sample_types as $type => $sample_control_id) {
		$filter_links[$type] = $main_link . '/SAMP_CONT_ID|' . $sample_control_id;
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
			'detail' => '/inventorymanagement/sample_masters/detail/%%Collection.id%%/%%SampleMaster.id%%'
		),
		'bottom' => array(
			'add' => $add_links,
			'filter' => $filter_links,
			'search' => $search_type_links
		)
	);

	$structure_override = array();
		
	$bank_list = array();
	foreach($banks as $new_bank) {
		$bank_list[$new_bank['Bank']['id']] = $new_bank['Bank']['name'];
	}
	$structure_override['Collection.bank_id'] = $bank_list;

	if(isset($arr_tissue_sources)) { $structure_override['SampleDetail.tissue_source'] = $arr_tissue_sources; }
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'index', 'links' => $structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
?>