<?php
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/study/study_fundings/detail/'.$atim_menu_variables['StudySummary.id'].'/%%StudyFunding.id%%',
		'bottom'=>array(
			'add'=>'/study/study_fundings/add/'.$atim_menu_variables['StudySummary.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>