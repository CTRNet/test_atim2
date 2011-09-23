<?php 
	$structure_links = array(
		'index' => '/clinicalannotation/participant_messages/detail/%%ParticipantMessage.participant_id%%/%%ParticipantMessage.id%%/',
		'bottom' => array(
			'new search' => ClinicalannotationAppController::$search_links,
			'add participant' => '/clinicalannotation/participants/add/'
		)
	);
	
	$settings = array('return' => true);
	if(isset($is_ajax)){
		$settings['actions'] = false;
	}else{
		$settings['header'] = __('search type', null).': '.__('participant messages', null);
	}
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'index', 
		'links' => $structure_links, 
		'settings' => $settings
	);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$page = $structures->build( $final_atim_structure, $final_options );

	if(isset($is_ajax)){
		echo json_encode(array('page' => $page, 'new_search_id' => AppController::getNewSearchId()));
	}else{
		echo $page;
	}
		
?>
