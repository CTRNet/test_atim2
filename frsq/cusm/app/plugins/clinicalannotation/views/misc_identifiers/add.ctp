<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/misc_identifiers/add/'.$atim_menu_variables['Participant.id'].'/'. $atim_menu_variables['MiscIdentifierControl.id'] .'/',
		'bottom'=>array('cancel'=>'/clinicalannotation/misc_identifiers/listall/'.$atim_menu_variables['Participant.id'].'/')
	);
	
	$structure_override = array();	

	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'override' => $structure_override);
	if($atim_structure['Structure']['alias'] == "incrementedmiscidentifiers"){
		$final_options['settings']['header'] = __("generated identifier", true);
	}
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>