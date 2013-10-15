<?php

	$structure_links = array(
		'top'=>'/ClinicalAnnotation/FamilyHistories/add/'.$atim_menu_variables['Participant.id'].'/',
		'bottom'=>array(
			'cancel'=>'/ClinicalAnnotation/FamilyHistories/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	// Set form structure and option 
/* ==> Note: Set both form structure and option into 2 variables to allow hooks to modify them */
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>