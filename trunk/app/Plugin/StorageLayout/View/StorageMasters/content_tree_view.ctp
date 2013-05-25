<?php
		
	// SETTINGS
	
	$structure_settings = array(
		'tree' => array(
			'StorageMaster' => 'StorageMaster',
			'AliquotMaster' => 'AliquotMaster',
			'TmaSlide' => 'TmaSlide'
		)
	);
	
	// LINKS
	$bottom = array();
	if(isset($search)){
		$add_links = array();
		foreach ($storage_controls_list as $storage_control) {
			$add_links[__($storage_control['StorageControl']['storage_type'])] = '/StorageLayout/StorageMasters/add/' . $storage_control['StorageControl']['id'];
		}
		ksort($add_links);
		$bottom = array(
			'search' => '/StorageLayout/StorageMasters/search', 
			'add' => $add_links);
	} else if(!$is_ajax && isset($storage_controls_list)) {
		$add_links = array();
		foreach ($storage_controls_list as $storage_control) {
			$add_links[__($storage_control['StorageControl']['storage_type'])] = '/StorageLayout/StorageMasters/add/' . $storage_control['StorageControl']['id'] . '/' . $atim_menu_variables['StorageMaster.id'];
		}
		ksort($add_links);
		$bottom = array('add to storage' => (empty($add_links)? '/underdevelopment/': $add_links));	
	}
	
	$structure_links = array(
		'tree'=>array(
			'StorageMaster' => array(
				'detail' => array(
					'link' => '/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%/1',
					'icon' => 'storage'),
				'access to all data' => array(
					'link' => '/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%/',
					'icon' => 'detail'
				)
			),
			'AliquotMaster' => array(
				'detail' => array(
					'link' => '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/1/0',
					'icon' => 'aliquot'),
				'access to all data' => array(
					'link'=> '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/',
					'icon' => 'detail'
				)
			),
			'TmaSlide' => array(
				'detail' => array(
					'link' => '/StorageLayout/TmaSlides/detail/%%TmaSlide.tma_block_storage_master_id%%/%%TmaSlide.id%%/1',
					'icon' => 'slide'),
				'access to all data' => array(
					'link'=> '/StorageLayout/TmaSlides/detail/%%TmaSlide.tma_block_storage_master_id%%/%%TmaSlide.id%%/',
					'icon' => 'detail'
				)
			)
		),
		'tree_expand' => array(
			'StorageMaster' => '/StorageLayout/StorageMasters/contentTreeView/%%StorageMaster.id%%/1/'
		),
		'bottom' => $bottom,		
		'ajax' => array(
			'index' => array(
				'detail' => array(
					'json' => array(
						'update' => 'frame',
						'callback' => 'set_at_state_in_tree_root'
					)
				)
			)
		)
	);
	
	// EXTRAS
	
	$structure_extras = array();
	$structure_extras[10] = '<div id="frame"></div>';	
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'tree', 'settings'=>$structure_settings, 'links'=>$structure_links, 'extras'=>$structure_extras);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
