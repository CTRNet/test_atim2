<?php
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/study/study_investigators/detail/'.$atim_menu_variables['StudySummary.id'].'/%%StudyInvestigator.id%%',
		'bottom'=>array(
			'add'=>'/study/study_investigators/add/'.$atim_menu_variables['StudySummary.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>