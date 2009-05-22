<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/study/study_results/listall/'.$atim_menu_variables['StudySummary.id'].'/',
			'edit'=>'/study/study_results/edit/'.$atim_menu_variables['StudySummary.id'].'/%%StudyResult.id%%/',
			'delete'=>'/study/study_results/delete/'.$atim_menu_variables['StudySummary.id'].'/%%StudyResult.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>