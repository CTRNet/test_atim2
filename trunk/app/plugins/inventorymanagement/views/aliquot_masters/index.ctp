<?php 

	$structure_links = array(
		'bottom' => array('add collection' => '/inventorymanagement/collections/add', 'new search' => InventorymanagementAppController::$search_links)
	);

	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'search', 
		'links' => array('top' => '/inventorymanagement/aliquot_masters/search/'.AppController::getNewSearchId()), 
		'settings' => array(
			'header' => array( 'title' => __('search type', null).': '.__('aliquots', null), 'description' => sprintf(__("more information about the types of samples and aliquots are available %s here", true), $help_url)),
			'actions' => false
		)
	);
	
	$final_atim_structure2 = $empty_structure;
	$final_options2 = array(
		'links'		=> $structure_links,
		'extras'	=> '<div class="ajax_search_results"></div>'
	);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
	$structures->build( $final_atim_structure2, $final_options2 );	

	
?>