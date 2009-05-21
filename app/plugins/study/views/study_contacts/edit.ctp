<?php 
	$structure_links = array(
		'top'=>'/study/study_contacts/edit/'.$atim_menu_variables['StudySummary.id'].'/%%StudyContact.id%%/',
		'bottom'=>array(
			'cancel'=>'/study/study_contacts/detail/'.$atim_menu_variables['StudySummary.id'].'/%%StudyContact.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>