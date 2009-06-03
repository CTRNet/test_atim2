<?php 
	$structure_links = array(
		'top'=>'/study/study_summaries/add/',
		'bottom'=>array(
			'cancel'=>'/study/study_summaries/listall/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>