<?php
	$search_type_links = array();
	$search_type_links['participants'] = array('link'=> '/clinicalannotation/participants/index/', 'icon' => 'search');
	$search_type_links['misc identifiers'] = array('link'=> '/clinicalannotation/misc_identifiers/index/', 'icon' => 'search');

	$structure_links = array(
		'top'=>'/clinicalannotation/participants/search/'.AppController::getNewSearchId(),
		'bottom'=>array(
			'add participant'=>'/clinicalannotation/participants/add',
			'new search' => $search_type_links
		)
	);

	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'search','links'=>$structure_links, 'settings' => array('header' => __('search type', null).': '.__('participants', null)));
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>