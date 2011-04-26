<?php 

	$structure_links = array();
	if($is_inventory_plugin_form){
		$add_links = array();
		foreach ($specimen_sample_controls_list as $sample_control) {
			$add_links[__($sample_control['SampleControl']['sample_type'], true)] = '/inventorymanagement/sample_masters/add/' . $atim_menu_variables['Collection.id'] . '/' . $sample_control['SampleControl']['id'];
		}
		ksort($add_links);
		
		$bottom_links = array('edit' => '/inventorymanagement/collections/edit/' . $atim_menu_variables['Collection.id']);
		if(empty($participant_id)){
			$bottom_links['participant'] = '/underdevelopment/';
		}else{
			$bottom_links['participant'] = array(
				'detail'		=> '/clinicalannotation/participants/profile/' . $participant_id,
				'collections'	=> array(
					'icon'	=> 'detail',
					'link'	=> '/clinicalannotation/product_masters/productsTreeView/' . $participant_id
					) 
					
			);
		}
		$bottom_links['add specimen'] = $add_links;
		$bottom_links['delete'] = '/inventorymanagement/collections/delete/' . $atim_menu_variables['Collection.id'];
		$structure_links['bottom'] = $bottom_links;
	}
		
	if($is_tree_view_detail_form){
		// Detail form displayed in tree view
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