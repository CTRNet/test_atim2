<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/clinicalannotation/misc_identifiers/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['MiscIdentifier.id'].'/',
			'delete'=>'/clinicalannotation/misc_identifiers/delete/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['MiscIdentifier.id'].'/',
			'list'=>'/clinicalannotation/misc_identifiers/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);

	$structure_override = array();
		
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>