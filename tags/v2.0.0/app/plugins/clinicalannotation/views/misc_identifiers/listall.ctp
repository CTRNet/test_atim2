<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/misc_identifiers/detail/'.$atim_menu_variables['Participant.id'].'/%%MiscIdentifier.id%%/'),
	);
	
	foreach($add_options as $option){
		$structure_links['bottom']['add'][$option['MiscIdentifierControl']['misc_identifier_name']] = '/clinicalannotation/misc_identifiers/add/'.$atim_menu_variables['Participant.id'].'/'.$option['MiscIdentifierControl']['id'].'/';
	}
	
	// Set form structure and option
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>