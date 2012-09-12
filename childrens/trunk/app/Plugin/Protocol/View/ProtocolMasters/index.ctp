<?php

	$add_links = array();
	foreach ( $protocol_controls as $protocol_control ) {
		$add_links[__($protocol_control['ProtocolControl']['tumour_group']).' - '.__($protocol_control['ProtocolControl']['type'])] = '/Protocol/ProtocolMasters/add/'.$protocol_control['ProtocolControl']['id'].'/';
	}
	ksort($add_links);
	
	$structure_links = array(
		'bottom'=>array(
			'add' => $add_links
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type'=>'search',
		'links' => array('top'=>array('search'=>'/Protocol/ProtocolMasters/search/'.AppController::getNewSearchId())), 
		'settings' => array('actions' => false, 'header' => __('search type', null).': '.__('protocols', null)),
	);
	
	$final_atim_structure2 = $empty_structure;
	$final_options2 = array(
		'links'		=> $structure_links,
		'extras'	=> '<div class="ajax_search_results"></div>'
	);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	$this->Structures->build( $final_atim_structure2, $final_options2 );
?>