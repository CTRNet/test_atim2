<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/Study/StudyReviews/listall/'.$atim_menu_variables['StudySummary.id'].'/',
			'edit'=>'/Study/StudyReviews/edit/'.$atim_menu_variables['StudySummary.id'].'/%%StudyReview.id%%/',
			'delete'=>'/Study/StudyReviews/delete/'.$atim_menu_variables['StudySummary.id'].'/%%StudyReview.id%%/'
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