<?php 

	$initial_specimen_sample_id = array_key_exists('SampleMaster.initial_specimen_sample_id', $atim_menu_variables)? $atim_menu_variables['SampleMaster.initial_specimen_sample_id']: '-1';
		
	// Manage add button
	$add_links = array();
	foreach ($specimen_sample_controls_list as $sample_control) {
		$add_links[__($sample_control['SampleControl']['sample_type'],true)] = '/inventorymanagement/sample_masters/add/' . $atim_menu_variables['Collection.id'] . '/' . $sample_control['SampleControl']['id'];
	}
	ksort($add_links);
	
	// Manage filter button
	$main_link = '/inventorymanagement/sample_masters/listAll/' . $atim_menu_variables['Collection.id'] . '/' . $initial_specimen_sample_id;
		
	$filter_links = array();	
	if(!empty($existing_specimen_sample_types)) {
		$filter_links['specimen'] = $main_link . '/CATEGORY|specimen';
		$filter_links_tmp = array();
		foreach ($existing_specimen_sample_types as $type => $sample_control_id) {
			$filter_links_tmp[__($type,true)] = $main_link . '/SAMP_CONT_ID|' . $sample_control_id;
		}
		ksort($filter_links_tmp);
		$filter_links = $filter_links + $filter_links_tmp;
		$filter_links['derivative'] = $main_link . '/CATEGORY|derivative';		
	}
	$filter_links_tmp = array();
	foreach ($existing_derivative_sample_types as $type => $sample_control_id) {
		$filter_links_tmp[__($type,true)] = $main_link . '/SAMP_CONT_ID|' . $sample_control_id;
	}
	ksort($filter_links_tmp);
	$filter_links = $filter_links + $filter_links_tmp;	
	$filter_links['no filter'] = $main_link . '/-1';
	$filter_links = (sizeof($filter_links) == 1)? '/underdevelopment/': $filter_links;

	// Manage search button	
	$search_type_links = array();
	$search_type_links['collections'] = array('link'=> '/inventorymanagement/collections/index/', 'icon' => 'search');
	$search_type_links['samples'] = array('link'=> '/inventorymanagement/sample_masters/index/', 'icon' => 'search');
	$search_type_links['aliquots'] = array('link'=> '/inventorymanagement/aliquot_masters/index/', 'icon' => 'search');
	
	$detail_link = ($model_to_use == 'ViewSample')? 
		'/inventorymanagement/sample_masters/detail/%%ViewSample.collection_id%%/%%ViewSample.sample_master_id%%': 
		'/inventorymanagement/sample_masters/detail/%%Collection.id%%/%%SampleMaster.id%%';
			
	$structure_links = array(
		'index' => array(
			'detail' => $detail_link
		),
		'bottom' => array(
			'add' => $add_links,
			'filter' => $filter_links,
			'new search' => $search_type_links
		)
	);
	
	// Clean up structure link
	if(empty($add_links)) unset($structure_links['bottom']['add']);

	$structure_settings = array('header' => __('filter', true) . ': ' . __($filter_value, true));

	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'index',  'data' => $samples_data, 'links' => $structure_links, 'override' => $structure_override, 'settings'=>$structure_settings);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
?>