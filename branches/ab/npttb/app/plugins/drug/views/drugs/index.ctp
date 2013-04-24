<?php

	$structure_links = array(
		'bottom'=>array(
			'new search' => array('link' => '/drug/drugs/search/', 'icon' => 'search'),
			'add'=>'/drug/drugs/add/'
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type'=>'search',
		'links'=> array('top'=>array('search'=>'/drug/drugs/search/'.AppController::getNewSearchId())),
		'settings' => array('actions' => false, 'header' => __('search type', null).': '.__('drugs', null)),
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