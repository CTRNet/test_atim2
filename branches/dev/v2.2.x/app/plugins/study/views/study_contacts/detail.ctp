<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/study/study_contacts/listall/'.$atim_menu_variables['StudySummary.id'].'/',
			'edit'=>'/study/study_contacts/edit/'.$atim_menu_variables['StudySummary.id'].'/%%StudyContact.id%%/',
			'delete'=>'/study/study_contacts/delete/'.$atim_menu_variables['StudySummary.id'].'/%%StudyContact.id%%/'
		)
	);
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>