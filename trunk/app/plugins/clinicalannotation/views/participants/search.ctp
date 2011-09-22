<?php 
	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/participants/profile/%%Participant.id%%'),
		'bottom'=>array(
			'add participant'=>'/clinicalannotation/participants/add/', 
			'new search' => ClinicalannotationAppController::$search_links
		)
	);
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links, 'settings' => array('header' => __('search type', null).': '.__('participants', null)));
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>
