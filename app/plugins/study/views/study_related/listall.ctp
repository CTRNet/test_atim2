<?php
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/study/study_related/detail/'.$atim_menu_variables['StudySummary.id'].'/%%StudyRelated.id%%/',
		'bottom'=>array(
			'add'=>'/study/study_related/add/'.$atim_menu_variables['StudySummary.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>