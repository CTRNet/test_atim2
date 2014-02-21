<?php 
	$structure_links = array(
		'top'=>'/ClinicalAnnotation/ParticipantContacts/add/'.$atim_menu_variables['Participant.id'].'/',
		'bottom'=>array(
			'cancel'=>'/ClinicalAnnotation/ParticipantContacts/listall/'.$atim_menu_variables['Participant.id'].'/'
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