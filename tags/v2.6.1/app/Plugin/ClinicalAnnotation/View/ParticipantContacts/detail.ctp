<?php 
	$structure_links = array(
		'top'=>NULL,
		'bottom'=>array(
			'edit'=>'/ClinicalAnnotation/ParticipantContacts/edit/'.$atim_menu_variables['Participant.id'].'/%%ParticipantContact.id%%/',
			'delete'=>'/ClinicalAnnotation/ParticipantContacts/delete/'.$atim_menu_variables['Participant.id'].'/%%ParticipantContact.id%%/',
			'list'=>'/ClinicalAnnotation/ParticipantContacts/listall/'.$atim_menu_variables['Participant.id'].'/'
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