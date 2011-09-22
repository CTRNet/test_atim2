<?php 
	$structure_links = array(
		'index' => array('detail' => '/inventorymanagement/aliquot_masters/detail/%%ViewAliquot.collection_id%%/%%ViewAliquot.sample_master_id%%/%%ViewAliquot.aliquot_master_id%%'),
		'bottom' => array(
			'add collection' => '/inventorymanagement/collections/add', 
			'new search' => InventorymanagementAppController::$search_links)
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'index', 'links' => $structure_links, 'override' => $structure_override, 'settings' => array('header' => array( 'title' => __('search type', null).': '.__('aliquots', null), 'description' => sprintf(__("more information about the types of samples and aliquots are available %s here", true), $help_url))));
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	

?>
