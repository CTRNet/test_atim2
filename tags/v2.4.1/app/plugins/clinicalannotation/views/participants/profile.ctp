<?php
	// 1- PARTICIPANT PROFILE
	$structure_links = array(
		'index'=>array(),
		'bottom'=>array(
			'new search' => ClinicalannotationAppController::$search_links,
			'edit'=>'/clinicalannotation/participants/edit/'.$atim_menu_variables['Participant.id'],
			'delete'=>'/clinicalannotation/participants/delete/'.$atim_menu_variables['Participant.id']			
		)
	);
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'detail', 'settings' => array('actions' => false));
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
	// 2- PARTICIPANT IDENTIFIER
	
	$structure_links['index'] = array('detail'=>'/clinicalannotation/misc_identifiers/detail/'.$atim_menu_variables['Participant.id'].'/%%MiscIdentifier.id%%/');
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure_for_misc_identifiers; 
	$final_options = array('type'=>'index', 'links'=>$structure_links, 'override'=>$structure_override, 'data' => $participant_identifiers_data, 'settings' => array('header' => __('misc identifiers', null)));
		
	// CUSTOM CODE
	$hook_link = $structures->hook('identifiers');
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
	
?>