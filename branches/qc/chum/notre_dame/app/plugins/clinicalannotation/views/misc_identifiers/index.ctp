<?php 

	$search_type_links = array();
	$search_type_links['participants'] = '/clinicalannotation/participants/index/';
	$search_type_links['misc identifiers'] = '/clinicalannotation/misc_identifiers/index/';
		
	$structure_links = array(
		'top' => '/clinicalannotation/misc_identifiers/search',
		'bottom' => array('new search type' => $search_type_links)
	);

	$structure_override = array();
	$structure_override['MiscIdentifier.identifier_name'] = $identifier_names_list;		
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'search', 'links' => $structure_links, 'override' => $structure_override, 'settings' => array('header' => __('search type', null).': '.__('misc identifiers', null)));
		
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
?>