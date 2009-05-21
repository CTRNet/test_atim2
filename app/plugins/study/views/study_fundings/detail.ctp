<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/study/study_fundings/listall/'.$atim_menu_variables['StudySummary.id'].'/',
			'edit'=>'/study/study_fundings/edit/'.$atim_menu_variables['StudySummary.id'].'/%%StudyFunding.id%%/',
			'delete'=>'/study/study_fundings/delete/'.$atim_menu_variables['StudySummary.id'].'/%%StudyFunding.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>