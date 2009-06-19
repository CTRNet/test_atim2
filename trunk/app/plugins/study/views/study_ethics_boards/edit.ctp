<?php 
	$structure_links = array(
		'top'=>'/study/study_ethics_boards/edit/'.$atim_menu_variables['StudySummary.id'].'/%%StudyEthicsBoard.id%%/',
		'bottom'=>array(
			'cancel'=>'/study/study_ethics_boards/detail/'.$atim_menu_variables['StudySummary.id'].'/%%StudyEthicsBoard.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>