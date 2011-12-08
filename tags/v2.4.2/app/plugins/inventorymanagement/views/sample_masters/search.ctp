<?php 
	$structure_links = array(
		'index' => array('detail' => '/inventorymanagement/sample_masters/detail/%%ViewSample.collection_id%%/%%ViewSample.sample_master_id%%'),
		'bottom' => array(
			'new search' => InventorymanagementAppController::$search_links,
			'add collection' => '/inventorymanagement/collections/add' 
		)
	);
	
	$settings = array('return' => true);
	if(isset($is_ajax)){
		$settings['actions'] = false;
	}else{
		$settings['header'] = array( 'title' => __('search type', null).': '.__('samples', null), 'description' => sprintf(__("more information about the types of samples and aliquots are available %s here", true), $help_url));
	}
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'index', 
		'links' => $structure_links, 
		'settings' => $settings
	); 
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$page = $structures->build( $final_atim_structure, $final_options );
	if(isset($is_ajax)){
		echo json_encode(array(
			'page' => $shell->validationHtml().$page, 
			'new_search_id' => AppController::getNewSearchId() 
		));
	}else{
		echo $page;
	}
?>
