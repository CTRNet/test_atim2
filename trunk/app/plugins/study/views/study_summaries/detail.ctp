<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/study/study_summaries/listall/',
			'edit'=>'/study/study_summaries/edit/%%StudySummary.id%%/',
			'delete'=>'/study/study_summaries/delete/%%StudySummary.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>