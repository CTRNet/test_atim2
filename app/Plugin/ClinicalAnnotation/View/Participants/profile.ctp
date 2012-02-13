<?php
	$identifiers_menu = array();
	foreach($identifier_controls_list as $identifier_ctrl){
		$identifiers_menu[$identifier_ctrl['MiscIdentifierControl']['misc_identifier_name']] = '/ClinicalAnnotation/MiscIdentifiers/add/'.$atim_menu_variables['Participant.id'].'/'.$identifier_ctrl['MiscIdentifierControl']['id'];
	}
	if(empty($identifiers_menu)){
		$identifiers_menu = '/underdev/';
	}

	// 1- PARTICIPANT PROFILE
	$structure_links = array(
		'index'=>array(),
		'bottom'=>array(
			'new search'	=> ClinicalAnnotationAppController::$search_links,
			'edit'			=> '/ClinicalAnnotation/Participants/edit/'.$atim_menu_variables['Participant.id'],
			'delete'		=> '/ClinicalAnnotation/Participants/delete/'.$atim_menu_variables['Participant.id'],
			'add identifier'=> $identifiers_menu
		)
	);
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'detail', 'settings' => array('actions' => false));
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
	// 2- PARTICIPANT IDENTIFIER
	
	$structure_links['index'] = array(
		'edit'		=> '/ClinicalAnnotation/MiscIdentifiers/edit/'.$atim_menu_variables['Participant.id'].'/%%MiscIdentifier.id%%/',
		'delete'	=> '/ClinicalAnnotation/MiscIdentifiers/delete/'.$atim_menu_variables['Participant.id'].'/%%MiscIdentifier.id%%/',
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure_for_misc_identifiers; 
	$final_options = array('type'=>'index', 'links'=>$structure_links, 'override'=>$structure_override, 'data' => $participant_identifiers_data, 'settings' => array('header' => __('misc identifiers', null)));
		
	// CUSTOM CODE
	$hook_link = $this->Structures->hook('identifiers');
	if( $hook_link ) { 
		require($hook_link); 
	}

	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	
	
?>