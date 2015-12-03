<?php 
	$structure_links = array(
		'index'=>array(
			'edit'=>'/Study/StudySummaries/stdRefEdit/%%StudyReference.id%%/',
			'delete'=>'/Study/StudySummaries/stdRefDelete/%%StudyReference.id%%/'
		),
		'bottom' => array(
			'add'=> '/Study/StudySummaries/stdRefAdd/'.$atim_menu_variables['StudySummary.id'].'/',
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links);
	
	$this->Structures->build( $final_atim_structure, $final_options );
?>