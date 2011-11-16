<?php
	$structure_links = array(
		'bottom' => array(
			'new search' => array('icon' => 'search', 'link' => '/study/study_summaries/search'),
			'add'=> '/study/study_summaries/add',
		)
	);

	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type'		=> 'search',
		'links'		=> array('top' => '/study/study_summaries/search/'.AppController::getNewSearchId().'/'),
		'settings'	=> array('header' => __('search type', null).': '.__('study and project', null), 'actions' => false)
	);
	
	$final_atim_structure2 = $empty_structure;
	$final_options2 = array(
		'links'		=> $structure_links,
		'extras'	=> '<div class="ajax_search_results"></div>'
	);
	
	
	
	// CUSTOM CODE
	$hook_link = $structures->hook('index');//when the caller is search, the hook will be 'search_index.php'
	if( $hook_link ) { 
		require($hook_link); 
	}
	
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	$structures->build( $final_atim_structure2, $final_options2 );
