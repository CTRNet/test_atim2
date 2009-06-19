<?php 
	$structure_links = array(
		'top'=>'/study/study_ethics_boards/add/'.$atim_menu_variables['StudySummary.id'].'/',
		'bottom'=>array(
			'cancel'=>'/study/study_ethics_boards/listall/'.$atim_menu_variables['StudySummary.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>