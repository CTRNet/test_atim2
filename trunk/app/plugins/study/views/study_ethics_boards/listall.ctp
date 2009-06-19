<?php
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/study/study_ethics_boards/detail/'.$atim_menu_variables['StudySummary.id'].'/%%StudyEthicsBoard.id%%/',
		'bottom'=>array(
			'add'=>'/study/study_ethics_boards/add/'.$atim_menu_variables['StudySummary.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>