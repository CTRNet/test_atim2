<?php 
	$structure_links = array(
		'index' => '/ClinicalAnnotation/ParticipantMessages/detail/%%ParticipantMessage.participant_id%%/%%ParticipantMessage.id%%/',
		'bottom' => array(
			'add participant' => '/ClinicalAnnotation/Participants/add/'
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
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$page = $this->Structures->build( $final_atim_structure, $final_options );

	if(isset($is_ajax)){
		$this->layout = 'json';
		$this->json = array('page' => $page, 'new_search_id' => AppController::getNewSearchId());
	}else{
		echo $page;
	}
		
?>
