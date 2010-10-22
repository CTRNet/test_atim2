<?php 

	$structure_links = array();
	if($is_inventory_plugin_form){
		$add_links = array();
		foreach ($specimen_sample_controls_list as $sample_control) {
			$add_links[__($sample_control['SampleControl']['sample_type'], true)] = '/inventorymanagement/sample_masters/add/' . $atim_menu_variables['Collection.id'] . '/' . $sample_control['SampleControl']['id'];
		}
		ksort($add_links);
		
		$structure_links['bottom'] = array(
			'edit' => '/inventorymanagement/collections/edit/' . $atim_menu_variables['Collection.id'], 
			'access to participant' => array(
				'link' => empty($participant_id)? '/underdevelopment/': '/clinicalannotation/participants/profile/' . $participant_id, 
				'icon' => 'participant'),
			'add specimen' => $add_links,
			'delete' => '/inventorymanagement/collections/delete/' . $atim_menu_variables['Collection.id']
		);
	}
		
	if($is_tree_view_detail_form){
		// Detail form displayed in tree view: Add button to access all sample data
		$structure_links['bottom']['access to all data'] = array(
			'link'=> '/inventorymanagement/collections/detail/' . $atim_menu_variables['Collection.id'] . '/',
			'icon' => 'access_to_data');
	}else{
		// General detail form display
		$search_type_links = array();
		$search_type_links['collections'] = array('link'=> '/inventorymanagement/collections/index/', 'icon' => 'search');
		$search_type_links['samples'] = array('link'=> '/inventorymanagement/sample_masters/index/', 'icon' => 'search');
		$search_type_links['aliquots'] = array('link'=> '/inventorymanagement/aliquot_masters/index/', 'icon' => 'search');
	
		$structure_links['bottom']['new search'] = $search_type_links;
	}
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
	
?>