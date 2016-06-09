<?php
	
	// Set links and settings
	$structure_links = array();
	$settings =  array('header' => __('tma slide'), 'actions' => ($is_from_tree_view_or_layout)? true : false);
	
	//Basic
	$structure_links = array(
		'bottom' => array(
			'edit' => '/StorageLayout/TmaSlides/edit/' . $atim_menu_variables['StorageMaster.id'] . '/' . $atim_menu_variables['TmaSlide.id'].'/1',
			'add tma slide use' => '/StorageLayout/TmaSlideUses/add/' . $atim_menu_variables['TmaSlide.id'],
			'delete' => '/StorageLayout/TmaSlides/delete/' . $atim_menu_variables['StorageMaster.id'] . '/' . $atim_menu_variables['TmaSlide.id']
		)
	);		
	
	//Clean up based on form type 
	if($is_from_tree_view_or_layout == 1) {
		// Tree view
		unset($structure_links['bottom']['list']);
	
	} else if($is_from_tree_view_or_layout == 2) {
		// Storage Layout
		$structure_links = array();
		$structure_links['bottom']['access to all data'] = '/StorageLayout/TmaSlides/detail/'. $atim_menu_variables['StorageMaster.id'] . '/' . $atim_menu_variables['TmaSlide.id'];
		
	}
				
	$form_override = array();
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'settings' => $settings);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	
	
	// TMA Slide Uses
	
	if(!$is_from_tree_view_or_layout) {
		
		// Orders
		
		if(Configure::read('order_item_type_config') != '2') {
			$final_atim_structure = array();
			$final_options = array(
				'links'	=> $structure_links,
				'settings' => array(
					'actions' => false,
					'header' => __('orders', null)
				), 'extras' => array('end' => $this->Structures->ajaxIndex('Order/OrderItems/listAllOrderItemsLinkedToOneObject/TmaSlide/'.$atim_menu_variables['TmaSlide.id'])));
		
			// CUSTOM CODE
			$hook_link = $this->Structures->hook('orders');
			if( $hook_link ) {
				require($hook_link);
			}
			
			// BUILD FORM
			$this->Structures->build( $final_atim_structure, $final_options );
		}
		
		// Uses
		
		$final_atim_structure = array();
		$final_options = array(
			'links'	=> $structure_links,
			'settings' => array(
				'header' => __('analysis/scoring', null)
			), 'extras' => array('end' => $this->Structures->ajaxIndex('StorageLayout/TmaSlideUses/listAll/'.$atim_menu_variables['StorageMaster.id'] . '/' . $atim_menu_variables['TmaSlide.id'])));
		
		// CUSTOM CODE
		$hook_link = $this->Structures->hook('uses');
		if( $hook_link ) {
			require($hook_link);
		}
		
		// BUILD FORM
		$this->Structures->build( $final_atim_structure, $final_options );

	}
			
?>