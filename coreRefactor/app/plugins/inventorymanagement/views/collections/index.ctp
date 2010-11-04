<?php 

	$search_type_links = array();
	$search_type_links['collections'] = array('link'=> '/inventorymanagement/collections/index/', 'icon' => 'search');
	$search_type_links['samples'] = array('link'=> '/inventorymanagement/sample_masters/index/', 'icon' => 'search');
	$search_type_links['aliquots'] = array('link'=> '/inventorymanagement/aliquot_masters/index/', 'icon' => 'search');

	$structure_override = array();
	$structure_links['top'] = '/inventorymanagement/collections/search';
	if(!isset($is_ccl_ajax) || !$is_ccl_ajax){
		$structure_links['bottom'] = array('add collection' => '/inventorymanagement/collections/add', 'new search' => $search_type_links);
	}else{
		//forece participant collection
		foreach($atim_structure['StructureFormat'] as $key => $field){
			if($field['StructureField']['field'] == "collection_property"){
				$atim_structure['StructureFormat'][$key]['flag_search_readonly'] = true;
				break;
			}
		}
		$structure_override['ViewCollection.collection_property'] = "participant collection";
	}
	
	
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'search', 'links' => $structure_links, 'override' => $structure_override, 'settings' => array('header' => __('search type', null).': '.__('collections', null)));
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
			
?>