<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/clinicalannotation/correspondences/listall/'.$atim_menu_variables['Participant.id'].'/',
			'edit'=>'/clinicalannotation/correspondences/edit/'.$atim_menu_variables['Participant.id'].'/%%Correspondence.id%%/',
			'delete'=>'/clinicalannotation/correspondences/delete/'.$atim_menu_variables['Participant.id'].'/%%Correspondence.id%%/'
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