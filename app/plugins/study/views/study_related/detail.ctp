<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/study/study_related/listall/'.$atim_menu_variables['StudySummary.id'].'/',
			'edit'=>'/study/study_related/edit/'.$atim_menu_variables['StudySummary.id'].'/%%StudyRelated.id%%/',
			'delete'=>'/study/study_related/delete/'.$atim_menu_variables['StudySummary.id'].'/%%StudyRelated.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>