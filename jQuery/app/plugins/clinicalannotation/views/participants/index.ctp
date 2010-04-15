<?php 

	$search_type_links = array();
	$search_type_links['participants'] = '/clinicalannotation/participants/index/';
	$search_type_links['misc identifiers'] = '/clinicalannotation/misc_identifiers/index/';

	$structure_links = array(
		'top'=>'/clinicalannotation/participants/search',
		'bottom'=>array(
			'add'=>'/clinicalannotation/participants/add',
			'new search type' => $search_type_links
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