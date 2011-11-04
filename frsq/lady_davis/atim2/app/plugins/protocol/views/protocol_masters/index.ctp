<?php

	$add_links = array();
	foreach ( $protocol_controls as $protocol_control ) {
		$add_links[__($protocol_control['ProtocolControl']['tumour_group'],true).' - '.__($protocol_control['ProtocolControl']['type'],true)] = '/protocol/protocol_masters/add/'.$protocol_control['ProtocolControl']['id'].'/';
	}
	ksort($add_links);
	
	$structure_links = array(
		'bottom'=>array(
			'new search' => array('link' => '/protocol/protocol_masters/search/', 'icon' => 'search'),
			'add' => $add_links
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type'=>'search',
		'links' => array('top'=>array('search'=>'/protocol/protocol_masters/search/'.AppController::getNewSearchId())), 
		'settings' => array('actions' => false, 'header' => __('search type', null).': '.__('protocols', null)),
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