<?php
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/study/study_contacts/detail/'.$atim_menu_variables['StudySummary.id'].'/%%StudyContact.id%%',
		'bottom'=>array(
			'add'=>'/study/study_contacts/add/'.$atim_menu_variables['StudySummary.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>