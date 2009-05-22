<?php 
	$structure_links = array(
		'top'=>'/study/study_results/edit/'.$atim_menu_variables['StudySummary.id'].'/%%StudyResult.id%%/',
		'bottom'=>array(
			'cancel'=>'/study/study_results/detail/'.$atim_menu_variables['StudySummary.id'].'/%%StudyResult.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>