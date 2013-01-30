<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/consent_masters/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['ConsentControl.id'].'/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/consent_masters/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structure_settings = array('header' => __($consent_type, null));
			
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'settings'=>$structure_settings);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>