<?php 
	$structure_override = array();
	$structure_links['top'] = '/inventorymanagement/collections/search/'.AppController::getNewSearchId();
	$settings = array('header' => array('title' => __('search type', null).': '.__('collections', null), 'description' => sprintf(__("more information about the types of samples and aliquots are available %s here", true), $help_url)));
	$dropdown = null;
	if(!isset($is_ccl_ajax) || !$is_ccl_ajax){
		$structure_links['bottom'] = array('add collection' => '/inventorymanagement/collections/add', 'new search' => InventorymanagementAppController::$search_links);
	}else{
		//forece participant collection
		foreach($atim_structure['StructureFormat'] as $key => $field){
			if($field['StructureField']['field'] == "collection_property"){
				$atim_structure['StructureFormat'][$key]['flag_search_readonly'] = true;
				break;
			}
		}
		$structure_override['ViewCollection.collection_property'] = "participant collection";
		$dropdown['ViewCollection.collection_property'] = array("participant collection" => __("participant collection", true));
	}
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'search', 'links' => $structure_links, 'override' => $structure_override, 'settings' => $settings);
	
	if($dropdown !== null){
		$final_options['dropdown_options'] = $dropdown;
	}
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
			
?>