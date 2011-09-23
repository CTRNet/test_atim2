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
	
	$settings = array('return' => true);
	if(isset($is_ajax)){
		$settings['actions'] = false;
	}
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type'=>'index',
		'links' => $structure_links,
		'settings' => $settings
	);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$form = $structures->build( $final_atim_structure, $final_options );
	if(isset($is_ajax)){
		echo json_encode(array('page' => $form, 'new_search_id' => AppController::getNewSearchId()));
	}else{
		echo $form;
	}

?>