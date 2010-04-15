<?php 

	// Build Link
	$add_identifiers_link = array();
	foreach($identifier_controls_list as $option){
		$add_identifiers_link[$option['MiscIdentifierControl']['misc_identifier_name']] = '/clinicalannotation/misc_identifiers/add/'.$atim_menu_variables['Participant.id'].'/'.$option['MiscIdentifierControl']['id'].'/';
	}
		
	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/misc_identifiers/detail/'.$atim_menu_variables['Participant.id'].'/%%MiscIdentifier.id%%/'),
		'bottom'=>array('add'=>$add_identifiers_link)
	);
	
	$structure_override = array();
	$structure_override['MiscIdentifier.identifier_name'] = $identifier_names_list;	

	// Set form structure and option
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>