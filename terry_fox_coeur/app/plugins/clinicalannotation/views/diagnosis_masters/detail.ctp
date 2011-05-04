<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/clinicalannotation/diagnosis_masters/edit/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
			'delete'=>'/clinicalannotation/diagnosis_masters/delete/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
			'list'=>'/clinicalannotation/diagnosis_masters/listall/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/'
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