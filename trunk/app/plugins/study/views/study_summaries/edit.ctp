<?php 
	$structure_links = array(
		'top'=>'/study/study_summaries/edit/%%StudySummary.id%%/',
		'bottom'=>array(
			'cancel'=>'/study/study_summaries/detail/%%StudySummary.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>
