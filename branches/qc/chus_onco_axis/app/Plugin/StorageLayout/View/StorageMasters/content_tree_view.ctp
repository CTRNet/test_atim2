<?php
		
	// SETTINGS
	
	$structure_settings = array(
		'tree' => array(
			'StorageMaster' => 'StorageMaster',
			'AliquotMaster' => 'AliquotMaster',
			'TmaBlock' => 'TmaBlock',
			'TmaSlide' => 'TmaSlide',
			'Generated' => 'Generated'
		)
	);
	
	// LINKS
	$bottom = array();
	if(isset($search)){
		$bottom = array(
			'search' => '/StorageLayout/StorageMasters/search', 
			'add' => $add_links);
	} else if(!$is_ajax && isset($add_links)) {
		$bottom = array('add to storage' => $add_links);	
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
			'TmaBlock' => array(
				'detail' => array(
					'link' => '/StorageLayout/StorageMasters/detail/%%TmaBlock.id%%/1',
					'icon' => 'tma block'),
				'access to all data' => array(
					'link'=> '/StorageLayout/StorageMasters/detail/%%TmaBlock.id%%/',
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
			),
			'Generated' => array(
				'access to the list' => array(
					'link'=> '/StorageLayout/StorageMasters/contentListView/'.$atim_menu_variables['StorageMaster.id'],
					'icon' => 'detail'
				))
		),
		'tree_expand' => array(
			'StorageMaster' => '/StorageLayout/StorageMasters/contentTreeView/%%StorageMaster.id%%/1/',
			'TmaBlock' => '/StorageLayout/StorageMasters/contentTreeView/%%TmaBlock.id%%/1/'
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
	
//	pr($this->data);
//	pr($final_atim_structure['TmaBlock']);
	
