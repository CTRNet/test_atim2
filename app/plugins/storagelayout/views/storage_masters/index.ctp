<?php 

	$add_links = array();
	foreach ($storage_controls_list as $storage_control) {
		$add_links[__($storage_control['StorageControl']['storage_type'], true)] = '/storagelayout/storage_masters/add/' . $storage_control['StorageControl']['id'];
	}
	ksort($add_links);

	$structure_links = array(
		'bottom' => array(
			'add' => $add_links,
			'new search' => array('link' => '/storagelayout/storage_masters/search', 'icon' => 'search'),
			'tree view' => '/storagelayout/storage_masters/contentTreeView'
		) 
	);

	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'search', 
		'links' => array('top' => array('search' =>'/storagelayout/storage_masters/search/'.AppController::getNewSearchId())),
		'settings' => array(
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