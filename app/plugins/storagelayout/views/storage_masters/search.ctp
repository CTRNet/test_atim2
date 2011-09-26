<?php

	$add_links = array();
	foreach ($storage_controls_list as $storage_control) {
		$add_links[__($storage_control['StorageControl']['storage_type'], true)] = '/storagelayout/storage_masters/add/' . $storage_control['StorageControl']['id'];
	}
	ksort($add_links);
	
	$settings = array('return' => true);
	if(isset($is_ajax)){
		$settings['actions'] = false;
		$settings['header'] = AppController::$result_are_unique_ctrl ? " " : null;
	}
	
	$structure_links = array(
		'index' => array('detail' => '/storagelayout/storage_masters/detail/%%StorageMaster.id%%'),
		'bottom' => array(
			'new search' => array('link' => '/storagelayout/storage_masters/search', 'icon' => 'search'),
			'add' => $add_links,
			'tree view' => '/storagelayout/storage_masters/contentTreeView'
		) 
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'index', 'links' => $structure_links, 'settings' => $settings);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$form = $structures->build( $final_atim_structure, $final_options );
	if(isset($is_ajax)){
		echo json_encode(array(
			'page' => $form, 
			'new_search_id' => AppController::getNewSearchId()
		));
	}else{
		echo $form;
	}
	
?>