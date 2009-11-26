<?php 
	
	$structure_links = array(
		'top'=>'/clinicalannotation/family_histories/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['FamilyHistory.id'],
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/family_histories/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['FamilyHistory.id']
		)
	);
	
	// Set form structure and option 
/* ==> Note: Set both form structure and option into 2 variables to allow hooks to modify them */
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>
