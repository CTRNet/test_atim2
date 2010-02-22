<?php 
	$structure_links = array(
		'top'=>'/study/study_summaries/edit/%%StudySummary.id%%/',
		'bottom'=>array(
			'cancel'=>'/study/study_summaries/detail/%%StudySummary.id%%/'
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