<?php
	// 1- PARTICIPANT PROFILE
	$structure_links = array(
		'index'=>array(),
		'bottom'=>array(
			'new search' => ClinicalAnnotationAppController::$search_links,
			'edit'=>'/ClinicalAnnotation/Participants/edit/'.$atim_menu_variables['Participant.id'],
			'delete'=>'/ClinicalAnnotation/Participants/delete/'.$atim_menu_variables['Participant.id']			
		)
	);
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'detail', 'settings' => array('actions' => false));
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
	// 2- PARTICIPANT IDENTIFIER
	
	$structure_links['index'] = array('detail'=>'/ClinicalAnnotation/MiscIdentifiers/detail/'.$atim_menu_variables['Participant.id'].'/%%MiscIdentifier.id%%/');
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure_for_misc_identifiers; 
	$final_options = array('type'=>'index', 'links'=>$structure_links, 'override'=>$structure_override, 'data' => $participant_identifiers_data, 'settings' => array('header' => __('misc identifiers', null)));
		
	// CUSTOM CODE
	$hook_link = $this->Structures->hook('identifiers');
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	
	
?>