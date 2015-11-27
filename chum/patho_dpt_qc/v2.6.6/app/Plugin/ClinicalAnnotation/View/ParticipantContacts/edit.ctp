<?php 
	$structure_links = array(
		'top'=>'/ClinicalAnnotation/ParticipantContacts/edit/'.$atim_menu_variables['Participant.id'].'/%%ParticipantContact.id%%/',
		'bottom'=>array(
			'cancel'=>'/ClinicalAnnotation/ParticipantContacts/detail/'.$atim_menu_variables['Participant.id'].'/%%ParticipantContact.id%%/'
		)
	);
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
?>