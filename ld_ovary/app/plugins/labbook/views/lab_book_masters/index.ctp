<?php 
	$settings = array(
		'actions' => false,
		'header' => __('search type', null).': '.__('lab book', null)
	);
	$add_links = array();

	foreach ($lab_book_controls_list as $control) {
		$add_links[__($control['LabBookControl']['book_type'], true)] = '/labbook/lab_book_masters/add/' . $control['LabBookControl']['id'];
	}
	ksort($add_links);
	$structure_links['bottom'] = array('add' => $add_links);

	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'search', 
		'links' => array('top' => array('search' =>'/labbook/lab_book_masters/search/'.AppController::getNewSearchId())), 
		'settings' => $settings
	);
	
	$final_atim_structure2 = $empty_structure;
	$final_options2 = array(
		'links'	=> array('bottom' => array('new search' => array('link' => '/labbook/lab_book_masters/search/', 'icon' => 'search'), 'add' => $add_links)),
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