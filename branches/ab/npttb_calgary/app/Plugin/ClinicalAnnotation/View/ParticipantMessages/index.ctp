<?php
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'search',
		'links' => array('top' => '/ClinicalAnnotation/ParticipantMessages/search/'.AppController::getNewSearchId()), 
		'settings' => array('header' => __('search type', null).': '.__('participant messages', null), 'actions' => false)
	);
	
	$final_atim_structure2 = $empty_structure;
	$final_options2 = array(
		'extras'	=> '<div class="ajax_search_results"></div>'
	);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook('index');//when the caller is search, the hook will be 'search_index.php'
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	$this->Structures->build( $final_atim_structure2, $final_options2 );
?>