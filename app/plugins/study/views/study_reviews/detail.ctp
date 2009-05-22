<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/study/study_reviews/listall/'.$atim_menu_variables['StudySummary.id'].'/',
			'edit'=>'/study/study_reviews/edit/'.$atim_menu_variables['StudySummary.id'].'/%%StudyReview.id%%/',
			'delete'=>'/study/study_reviews/delete/'.$atim_menu_variables['StudySummary.id'].'/%%StudyReview.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>