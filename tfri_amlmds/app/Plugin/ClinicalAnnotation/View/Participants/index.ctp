<?php
	require('search_links_n_options.php');
	$final_options['settings']['return'] = true;
	$final_options['settings']['pagination'] = false;
	$final_options['settings']['header'] = false;
	$final_options['settings']['actions'] = false;
	$last_5 = $this->Structures->build( $final_atim_structure, $final_options );

	$structure_links = array(
		'bottom'=>array(
			'add participant'=>'/ClinicalAnnotation/Participants/add'
		)
	);

	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type'		=> 'search',
		'links'		=> array('top' => '/ClinicalAnnotation/Participants/search/'.AppController::getNewSearchId().'/'),
		'settings'	=> array('header' => __('search type', null).': '.__('participants', null), 'actions' => false)
	);
	
	$final_atim_structure2 = $empty_structure;
	$final_options2 = array(
		'links'		=> $structure_links,
		'extras'	=> '<div class="ajax_search_results"></div><div class="ajax_search_results_default">'.$last_5.'</div>'
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
