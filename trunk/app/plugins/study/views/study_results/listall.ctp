<?php
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/study/study_results/detail/'.$atim_menu_variables['StudySummary.id'].'/%%StudyResult.id%%',
		'bottom'=>array(
			'add'=>'/study/study_results/add/'.$atim_menu_variables['StudySummary.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>