<?php 

	$add_links = array();
	foreach ($storage_controls_list as $storage_control) {
		$add_links[__($storage_control['StorageControl']['storage_type'], true)] = '/storagelayout/storage_masters/add/' . $storage_control['StorageControl']['id'];
	}
	ksort($add_links);

	$structure_links = array(
		'top' => array('search' =>'/storagelayout/storage_masters/search/'.AppController::getNewSearchId()),
		'bottom' => array('tree view' => '/storagelayout/storage_masters/contentTreeView', 'add' => $add_links)
	);

	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'search', 'links' => $structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>