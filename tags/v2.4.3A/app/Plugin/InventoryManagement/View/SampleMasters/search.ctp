<?php 
	$structure_links = array(
		'index' => array('detail' => '/InventoryManagement/SampleMasters/detail/%%ViewSample.collection_id%%/%%ViewSample.sample_master_id%%'),
		'bottom' => array(
			'new search' => InventoryManagementAppController::$search_links,
			'add collection' => '/InventoryManagement/collections/add' 
		)
	);
	
	$settings = array('return' => true);
	if(isset($is_ajax)){
		$settings['actions'] = false;
	}else{
		$settings['header'] = array( 'title' => __('search type', null).': '.__('samples', null), 'description' => __("more information about the types of samples and aliquots are available %s here", $help_url));
	}
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'index', 
		'links' => $structure_links, 
		'settings' => $settings
	); 
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$page = $this->Structures->build( $final_atim_structure, $final_options );
	if(isset($is_ajax)){
		echo json_encode(array(
			'page' => $this->Shell->validationHtml().$page, 
			'new_search_id' => AppController::getNewSearchId() 
		));
	}else{
		echo $page;
	}
?>
