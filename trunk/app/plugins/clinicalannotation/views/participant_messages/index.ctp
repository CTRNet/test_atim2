<?php
	$structure_links = array(
		'bottom'=>array(
			'new search' => ClinicalannotationAppController::$search_links
		)
	);

	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'search',
		'links' => array('top' => '/clinicalannotation/participant_messages/search/'.AppController::getNewSearchId()), 
		'settings' => array('header' => __('search type', null).': '.__('participant messages', null), 'actions' => false)
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