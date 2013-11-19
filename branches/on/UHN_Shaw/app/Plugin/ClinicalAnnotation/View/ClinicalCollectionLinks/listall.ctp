<?php
	
	// ------ 1- Link Display ---------------------------------------------------
	
	$structure_links = array(
		'index'=>array(
			'detail'=>'/ClinicalAnnotation/ClinicalCollectionLinks/detail/'.$atim_menu_variables['Participant.id'].'/%%Collection.id%%/',
			'collection' => array(
				'link' => '/InventoryManagement/Collections/detail/%%Collection.id%%/',
				'icon' => 'collection'
			)
		)
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links, 'override' => $structure_override, 'settings' => array('actions' => false, 'pagination' => false));
	
	if(!$is_ajax) $final_options['settings']['header'] = __('links to collections');
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
	// ------ 2- Collection Contents ---------------------------------------------------
	
	// SETTINGS
	
	if(!$is_ajax){
		$structure_settings = array(
			'tree'=>array(
				'Collection' => 'Collection',
			),
			'header' => __('collections content')
		);
		
		// LINKS
		$structure_links = array(
			'bottom'=>array(
				'add'=>'/ClinicalAnnotation/ClinicalCollectionLinks/add/'.$atim_menu_variables['Participant.id'].'/'
			),
			'tree'=>array(
				'Collection' => array(
					'detail' => array(
						'link' => '/InventoryManagement/Collections/detail/%%Collection.id%%/1',
						'icon' => 'collection'
					),
					'access to all data' => array(
						'link'=> '/InventoryManagement/Collections/detail/%%Collection.id%%/',
						'icon' => 'detail'
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
		
		$final_atim_structure = $tree_view_atim_structure; 
		$final_options = array('type' => 'tree', 'settings'=>$structure_settings, 'links'=>$structure_links, 'extras'=>$structure_extras, 'override' => $structure_override);
		
		// CUSTOM CODE
		$hook_link = $this->Structures->hook('tree_view');
		if( $hook_link ) { require($hook_link); }
			
		// BUILD FORM
		$this->Structures->build( $final_atim_structure, $final_options );	
	}
?>