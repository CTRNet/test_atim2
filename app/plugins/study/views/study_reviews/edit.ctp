<?php 
	$structure_links = array(
		'top'=>'/study/study_reviews/edit/'.$atim_menu_variables['StudySummary.id'].'/%%StudyReview.id%%/',
		'bottom'=>array(
			'cancel'=>'/study/study_reviews/detail/'.$atim_menu_variables['StudySummary.id'].'/%%StudyReview.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>