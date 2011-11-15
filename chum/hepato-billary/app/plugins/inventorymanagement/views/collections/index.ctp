<?php 
	$structure_override = array();
	$settings = array(
		'header' => array('title' => __('search type', null).': '.__('collections', null), 'description' => sprintf(__("more information about the types of samples and aliquots are available %s here", true), $help_url)),
		'actions' => false
	);
	
	$dropdown = null;
	if(isset($is_ccl_ajax)){
		//forece participant collection
		foreach($atim_structure['Sfs'] as &$field){
			if($field['field'] == "collection_property"){
				$field['flag_search_readonly'] = true;
				break;
			}
		}
		$structure_override['ViewCollection.collection_property'] = "participant collection";
		$dropdown['ViewCollection.collection_property'] = array("participant collection" => __("participant collection", true));
	}
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'search', 
		'links' => array('top' => '/inventorymanagement/collections/search/'.AppController::getNewSearchId()),
		'override' => $structure_override, 
		'settings' => $settings
	);
	if($dropdown !== null){
		$final_options['dropdown_options'] = $dropdown;
	}
	
	$final_atim_structure2 = $empty_structure;
	$final_options2 = array(
		'links' => isset($is_ccl_ajax) ? array() : array('bottom' => array(
			'new search' => InventorymanagementAppController::$search_links,
			'add collection' => '/inventorymanagement/collections/add'
		)),
		'extras'	=> '<div class="ajax_search_results"></div>'
	);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
	if(!isset($is_ccl_ajax)){
		$structures->build( $final_atim_structure2, $final_options2 );
	}
			
?>