<?php 

	$sample_master_id = array_key_exists('SampleMaster.id', $atim_menu_variables)? $atim_menu_variables['SampleMaster.id']: '-1';
		
	// Manage filter button
	$main_link = '/inventorymanagement/aliquot_masters/listAll/' . $atim_menu_variables['Collection.id'] . '/' . $sample_master_id;
		
	$filter_links = array();
	foreach ($existing_sample_aliquot_types as $controls_key => $sample_aliquot_type_data) {
		$filter_key = __($sample_aliquot_type_data['sample_type'], TRUE) . ' ' . __($sample_aliquot_type_data['aliquot_type'], TRUE);
		$filter_links[$filter_key] = $main_link . '/' . $controls_key;
	}
	ksort($filter_links);	
	$filter_links['no filter'] = $main_link . '/-1';
	$filter_links = (sizeof($filter_links) == 1)? '/underdevelopment/': $filter_links;

	// Create array of aliquot type that could be created for the studied sample for the ADD button 
	$add_aliquots = array();	
	foreach($allowed_aliquot_type as $aliquot_control) {
		$add_aliquots[__($aliquot_control['AliquotControl']['aliquot_type'],true)] = '/inventorymanagement/aliquot_masters/add/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $aliquot_control['AliquotControl']['id'];
	}	
	ksort($add_aliquots);	
	$add_aliquots = empty($add_aliquots)? '/underdevelopment/': $add_aliquots;

	// Manage search button	
	$search_type_links = array();
	$search_type_links['collections'] = array('link'=> '/inventorymanagement/collections/index/', 'icon' => 'search');
	$search_type_links['samples'] = array('link'=> '/inventorymanagement/sample_masters/index/', 'icon' => 'search');
	$search_type_links['aliquots'] = array('link'=> '/inventorymanagement/aliquot_masters/index/', 'icon' => 'search');

	$detail_link = ($model_to_use == 'ViewAliquot')? 
		'/inventorymanagement/aliquot_masters/detail/%%ViewAliquot.collection_id%%/%%ViewAliquot.sample_master_id%%/%%ViewAliquot.aliquot_master_id%%':
		'/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
			
	$structure_links = array(
		'index' => array(
			'detail' => $detail_link
		),
		'bottom' => array(
			'add aliquot' => $add_aliquots,
			'filter' => $filter_links,
			'new search' => $search_type_links
		)
	);
	
	$filter_value = 'no filter';
	if(!empty($sample_filter_value)) {
		$filter_value = __($sample_filter_value, true) . ' ' . __($aliquot_filter_value, true) ;
	} else if(!empty($aliquot_filter_value)) {
		$filter_value = __($aliquot_filter_value, true) ;
	}
		
	$structure_settings = array('header' => __('filter', true) . ': ' . __($filter_value, true));

	$structure_override = array();
	
	$final_atim_structure = $aliquots_listall_structure; 
	$final_options = array('type' => 'index', 'links' => $structure_links, 'override' => $structure_override, 'data' => $aliquots_data, 'settings'=>$structure_settings);
		
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	

?>