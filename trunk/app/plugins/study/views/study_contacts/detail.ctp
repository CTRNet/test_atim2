<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/study/study_contacts/listall/'.$atim_menu_variables['StudySummary.id'].'/',
			'edit'=>'/study/study_contacts/edit/'.$atim_menu_variables['StudySummary.id'].'/%%StudyContact.id%%/',
			'delete'=>'/study/study_contacts/delete/'.$atim_menu_variables['StudySummary.id'].'/%%StudyContact.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>