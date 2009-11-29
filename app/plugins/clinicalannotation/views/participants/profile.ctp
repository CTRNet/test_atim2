<?php 
	$structure_links = array(
		'bottom'=>array(
			'search'=>'/clinicalannotation/participants/index/',
			'list'=>'/clinicalannotation/participants/listall/',
			'edit'=>'/clinicalannotation/participants/edit/%%Participant.id%%',
			'delete'=>'/clinicalannotation/participants/delete/%%Participant.id%%'
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