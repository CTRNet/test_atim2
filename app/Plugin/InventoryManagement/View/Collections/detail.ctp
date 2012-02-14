<?php 

	$structure_links = array();
		
	$add_links = array();
	foreach ($specimen_sample_controls_list as $sample_control) {
		$add_links[__($sample_control['SampleControl']['sample_type'])] = '/InventoryManagement/SampleMasters/add/' . $atim_menu_variables['Collection.id'] . '/' . $sample_control['SampleControl']['id'];
	}
	ksort($add_links);
	
	$settings = array();
	$bottom_links = array(
		'edit'						=> '/InventoryManagement/collections/edit/' . $atim_menu_variables['Collection.id'],
		'delete'					=> '/InventoryManagement/collections/delete/' . $atim_menu_variables['Collection.id'],
		'copy for new collection'	=> array('link' => '/InventoryManagement/collections/add/0/'.$atim_menu_variables['Collection.id'], 'icon' => 'copy'),
		'add specimen'				=> $add_links,
		'add from template'			=> $templates
	);
	if(empty($participant_id)){
		$bottom_links['participant data'] = '/underdevelopment/';
	}else{
		$bottom_links['participant data'] = array(
			'profile'		=> array(
				'icon'	=> 'participant',
				'link'	=> '/ClinicalAnnotation/Participants/profile/' . $participant_id),
			'participant inventory'	=> array(
				'icon'	=> 'participant',
				'link'	=> '/ClinicalAnnotation/ProductMasters/productsTreeView/' . $participant_id
				) 
		);
	}
			
	
	
	if($is_from_tree_view){
		$settings = array('header' => __('collection'));
		$structure_links['bottom'] = $bottom_links;
	}else{
		$structure_links['bottom'] = array_merge(array('new search' => InventoryManagementAppController::$search_links), $bottom_links);
	}
		
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'settings' => $settings);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	
	
?>