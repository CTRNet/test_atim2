<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/study/study_ethics_boards/listall/'.$atim_menu_variables['StudySummary.id'].'/',
			'edit'=>'/study/study_ethics_boards/edit/'.$atim_menu_variables['StudySummary.id'].'/%%StudyEthicsBoard.id%%/',
			'delete'=>'/study/study_ethics_boards/delete/'.$atim_menu_variables['StudySummary.id'].'/%%StudyEthicsBoard.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>