<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/study/study_summaries/listall/',
			'edit'=>'/study/study_summaries/edit/%%StudySummary.id%%/',
			'delete'=>'/study/study_summaries/delete/%%StudySummary.id%%/'
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