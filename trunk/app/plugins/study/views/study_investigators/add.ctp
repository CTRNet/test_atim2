<?php 
	$structure_links = array(
		'top'=>'/study/study_investigators/add/'.$atim_menu_variables['StudySummary.id'].'/',
		'bottom'=>array(
			'cancel'=>'/study/study_investigators/listall/'.$atim_menu_variables['StudySummary.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>