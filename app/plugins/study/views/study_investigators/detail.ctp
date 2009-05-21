<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/study/study_investigators/listall/'.$atim_menu_variables['StudySummary.id'].'/',
			'edit'=>'/study/study_investigators/edit/'.$atim_menu_variables['StudySummary.id'].'/%%StudyInvestigator.id%%/',
			'delete'=>'/study/study_investigators/delete/'.$atim_menu_variables['StudySummary.id'].'/%%StudyInvestigator.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>