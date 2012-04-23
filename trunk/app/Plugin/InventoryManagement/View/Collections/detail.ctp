<?php 

	$structure_links = array();
		
	$add_links = array();
	foreach ($specimen_sample_controls_list as $sample_control) {
		$add_links[__($sample_control['SampleControl']['sample_type'])] = '/InventoryManagement/SampleMasters/add/' . $atim_menu_variables['Collection.id'] . '/' . $sample_control['SampleControl']['id'];
	}
	ksort($add_links);
	
	$settings = array('header' => __('collection details'));
	$bottom_links = array(
		'edit'						=> '/InventoryManagement/collections/edit/' . $atim_menu_variables['Collection.id'],
		'delete'					=> '/InventoryManagement/collections/delete/' . $atim_menu_variables['Collection.id'],
		'copy for new collection'	=> array('link' => '/InventoryManagement/collections/add/0/'.$atim_menu_variables['Collection.id'], 'icon' => 'copy'),
		'print barcodes'			=> array('link' => '/InventoryManagement/AliquotMasters/printBarcodes/model:Collection/id:'.$atim_menu_variables['Collection.id'], 'icon' => 'barcode'),
		'add specimen'				=> $add_links,
		'add from template'			=> $templates,
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
			
	if($is_ajax){
		$structure_links['bottom'] = $bottom_links;
	}else{
		$structure_links['bottom'] = array_merge(array('new search' => InventoryManagementAppController::$search_links), $bottom_links);
	}
		
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'settings' => $settings);
	
	if(!$is_ajax && !empty($sample_data)){
		$final_options['settings']['actions'] = false;
	}
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );

	if(!$is_ajax && !empty($sample_data)){
		$structure_settings = array(
			'tree'=>array(
				'SampleMaster'		=> 'SampleMaster'
			), 'header' => __('collection contents')
		);
		$structure_links['tree'] = array(
			'SampleMaster' => array(
				'detail' => array(
					'link' => '/InventoryManagement/SampleMasters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/1/',
					'icon' => 'flask'
				), 'access to all data' => array(
					'link'=> '/InventoryManagement/SampleMasters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/',
					'icon' => 'access_to_data'
				)
			)
		);
		$structure_links['tree_expand'] = array(
			'SampleMaster' => '/InventoryManagement/SampleMasters/contentTreeView/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/1/'
		);
		$structure_links['ajax'] = array(
			'index' => array(
				'detail' => array(
					'json' => array(
						'update' => 'frame',
						'callback' => 'set_at_state_in_tree_root'
					)
				)
			)
		);
		$final_options = array(
			'type' => 'tree',
				'data' => $sample_data		
		);
		
		
		
		
		$structure_extras = array();
		$structure_extras[10] = '<div id="frame"></div>';
		
		// BUILD
		$final_atim_structure = array('SampleMaster' => $sample_masters_for_collection_tree_view);
		$final_options = array(
			'type'		=> 'tree',
			'data'		=> $sample_data, 
			'settings'	=> $structure_settings, 
			'links'		=> $structure_links, 
			'extras'	=> $structure_extras
		);
		
		// CUSTOM CODE
		$hook_link = $this->Structures->hook();
		if( $hook_link ) {
			require($hook_link);
		}
		
		// BUILD FORM
		$this->Structures->build( $final_atim_structure, $final_options );
	}
	
?>