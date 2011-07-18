<?php

	$add_links = array();
	foreach ( $protocol_controls as $protocol_control ) {
		$add_links[__($protocol_control['ProtocolControl']['tumour_group'],true).' - '.__($protocol_control['ProtocolControl']['type'],true)] = '/protocol/protocol_masters/add/'.$protocol_control['ProtocolControl']['id'].'/';
	}

	$structure_links = array(
		'index'=>array('detail'=>'/protocol/protocol_masters/detail/%%ProtocolMaster.id%%'),
		'bottom'=>array(
			'add'=>$add_links,
			'search'=>'/protocol/protocol_masters/index'
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );

?>