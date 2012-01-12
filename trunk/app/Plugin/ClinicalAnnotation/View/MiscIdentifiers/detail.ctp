<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/ClinicalAnnotation/MiscIdentifiers/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['MiscIdentifier.id'].'/',
			'delete'=>'/ClinicalAnnotation/MiscIdentifiers/delete/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['MiscIdentifier.id'].'/',
			'list'=>'/ClinicalAnnotation/MiscIdentifiers/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);

	$structure_override = array();
		
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
?>