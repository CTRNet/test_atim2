<?php 

	$structure_links = array(
		'top' => '/inventorymanagement/aliquot_masters/search/'.AppController::getNewSearchId(),
		'bottom' => array('add collection' => '/inventorymanagement/collections/add', 'new search' => InventorymanagementAppController::$search_links)
	);

	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'search', 'links' => $structure_links, 'override' => $structure_override, 'settings' => array('header' => array( 'title' => __('search type', null).': '.__('aliquots', null), 'description' => sprintf(__("more information about the types of samples and aliquots are available %s here", true), $help_url))));
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	

	
?>