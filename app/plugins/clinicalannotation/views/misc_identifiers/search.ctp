<?php 
	$structure_links = array(
		'index' => array('detail' => '/clinicalannotation/participants/profile/%%Participant.id%%'),
		'bottom' => array(
			'add participant' => '/clinicalannotation/participants/add/',
			'new search' => ClinicalannotationAppController::$search_links
		)
	);
	
	$settings = array('return' => true);
	if(isset($is_ajax)){
		$settings['actions'] = false;
	}else{
		$settings['header'] = __('search type', null).': '.__('misc identifiers', null);
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
