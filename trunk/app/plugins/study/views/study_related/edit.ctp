<?php 
	$structure_links = array(
		'top'=>'/study/study_related/edit/'.$atim_menu_variables['StudySummary.id'].'/%%StudyRelated.id%%/',
		'bottom'=>array(
			'cancel'=>'/study/study_related/detail/'.$atim_menu_variables['StudySummary.id'].'/%%StudyRelated.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>