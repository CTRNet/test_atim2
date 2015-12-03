<?php 
	$structure_links = array(
		'index'=>array(
			'edit'=>'/Study/StudySummaries/stdQcReportEdit/%%StudyQualityControlReport.id%%/',
			'delete'=>'/Study/StudySummaries/stdQcReportDelete/%%StudyQualityControlReport.id%%/'
		),
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links);
	
	$this->Structures->build( $final_atim_structure, $final_options );
?>