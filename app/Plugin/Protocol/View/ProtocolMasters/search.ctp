<?php

	$add_links = array();
	foreach ( $protocol_controls as $protocol_control ) {
		$add_links[__($protocol_control['ProtocolControl']['tumour_group']).' - '.__($protocol_control['ProtocolControl']['type'])] = '/Protocol/ProtocolMasters/add/'.$protocol_control['ProtocolControl']['id'].'/';
	}

	$structure_links = array(
		'index'=>array('detail'=>'/Protocol/ProtocolMasters/detail/%%ProtocolMaster.id%%'),
		'bottom'=>array(
			'add'=>$add_links
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
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$form = $this->Structures->build( $final_atim_structure, $final_options );
	if(isset($is_ajax)){
		echo json_encode(array('page' => $this->Shell->validationHtml().$form, 'new_search_id' => AppController::getNewSearchId()));
	}else{
		echo $form;
	}

?>