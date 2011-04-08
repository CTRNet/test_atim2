<?php 
	$structure_links = array(
		'top'=>'/study/study_results/edit/'.$atim_menu_variables['StudySummary.id'].'/%%StudyResult.id%%/',
		'bottom'=>array(
			'cancel'=>'/study/study_results/detail/'.$atim_menu_variables['StudySummary.id'].'/%%StudyResult.id%%/'
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