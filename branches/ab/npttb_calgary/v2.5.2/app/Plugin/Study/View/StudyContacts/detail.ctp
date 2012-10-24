<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/Study/StudyContacts/listall/'.$atim_menu_variables['StudySummary.id'].'/',
			'edit'=>'/Study/StudyContacts/edit/'.$atim_menu_variables['StudySummary.id'].'/%%StudyContact.id%%/',
			'delete'=>'/Study/StudyContacts/delete/'.$atim_menu_variables['StudySummary.id'].'/%%StudyContact.id%%/'
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