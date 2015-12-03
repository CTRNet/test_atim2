<?php 
	$structure_links = array(
		'index'=>array(
			'edit'=>'/Study/StudySummaries/stdExtEvalEdit/%%StudyExternalEvaluation.id%%/',
			'delete'=>'/Study/StudySummaries/stdExtEvalDelete/%%StudyExternalEvaluation.id%%/'
		),
		'bottom' => array(
			'add'=> '/Study/StudySummaries/stdExtEvalAdd/'.$atim_menu_variables['StudySummary.id'].'/',
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links);
	
	$this->Structures->build( $final_atim_structure, $final_options );
?>