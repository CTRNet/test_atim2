<?php 

	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'search', 
		'links' => array('top' => '/InventoryManagement/AliquotMasters/search/'.AppController::getNewSearchId()), 
		'settings' => array(
			'header' => array( 'title' => __('search type', null).': '.__('aliquots', null), 'description' => __("more information about the types of samples and aliquots are available %s here", $help_url)),
			'actions' => false
		)
	);
	
	$final_atim_structure2 = $empty_structure;
	$final_options2 = array(
		'extras'	=> '<div class="ajax_search_results"></div>'
	);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	
	$this->Structures->build( $final_atim_structure2, $final_options2 );	
