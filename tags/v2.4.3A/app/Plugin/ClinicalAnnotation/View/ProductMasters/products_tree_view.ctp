<?php
	
	// SETTINGS
	
	$structure_settings = array(
		'tree'=>array(
			'Collection' => 'Collection',
		)
	);
	
	// LINKS
	$structure_links = array(
		'tree'=>array(
			'Collection' => array(
				'detail' => array(
					'link' => '/InventoryManagement/collections/detail/%%Collection.id%%/1',
					'icon' => 'collection'
				),
				'access to all data' => array(
					'link'=> '/InventoryManagement/collections/detail/%%Collection.id%%/',
					'icon' => 'access_to_data'
				)
			)
		),
		'tree_expand' => array(
			'Collection' => '/InventoryManagement/SampleMasters/contentTreeView/%%Collection.id%%/0/1/'
		),
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
	
	$structure_override = array();
	
	// BUILD
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'tree', 'settings'=>$structure_settings, 'links'=>$structure_links, 'extras'=>$structure_extras, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	
	
