<?php 

	$add_links = array();
	foreach ($storage_controls_list as $storage_control) {
		$add_links[__($storage_control['StorageControl']['storage_type'])] = '/StorageLayout/StorageMasters/add/' . $storage_control['StorageControl']['id'];
	}
	ksort($add_links);

	$structure_links = array(
		'bottom' => array(
			'add' => $add_links,
			'tree view' => '/StorageLayout/StorageMasters/contentTreeView'
		) 
	);

	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'search', 
		'links' => array('top' => array('search' =>'/StorageLayout/StorageMasters/search/'.(isset($is_ajax) ? '-1' : AppController::getNewSearchId()))),
		'settings' => array(
			'actions' => false,
			'header' => __('search type', null).': '.__('storages', null),
		)
	);
	$final_atim_structure2 = $empty_structure;
	$final_options2 = array(
		'links'		=> $structure_links,
		'extras'	=> '<div class="ajax_search_results"></div>'
	);
	if(isset($is_ajax)){
		unset($final_options2['links']['bottom']);
	}
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	$this->Structures->build( $final_atim_structure2, $final_options2 );
	
?>