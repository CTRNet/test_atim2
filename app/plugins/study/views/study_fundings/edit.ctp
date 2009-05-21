<?php 
	$structure_links = array(
		'top'=>'/study/study_fundings/edit/'.$atim_menu_variables['StudySummary.id'].'/%%StudyFunding.id%%/',
		'bottom'=>array(
			'cancel'=>'/study/study_fundings/detail/'.$atim_menu_variables['StudySummary.id'].'/%%StudyFunding.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>