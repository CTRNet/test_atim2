<?php 

	$structure_links = array(
		'top'=>NULL,
		'index'=>array('detail'=>'/study/study_summaries/detail/%%StudySummary.id%%/'),
		'bottom'=>array(
			'add'=>'/study/study_summaries/add/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>