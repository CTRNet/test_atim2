<?php
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/study/study_reviews/detail/'.$atim_menu_variables['StudySummary.id'].'/%%StudyReview.id%%',
		'bottom'=>array(
			'add'=>'/study/study_reviews/add/'.$atim_menu_variables['StudySummary.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>