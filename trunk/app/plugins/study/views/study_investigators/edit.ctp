<?php 
	$structure_links = array(
		'top'=>'/study/study_investigators/edit/'.$atim_menu_variables['StudySummary.id'].'/%%StudyInvestigator.id%%/',
		'bottom'=>array(
			'cancel'=>'/study/study_investigators/detail/'.$atim_menu_variables['StudySummary.id'].'/%%StudyInvestigator.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>