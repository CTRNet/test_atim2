<?php
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/study/study_ethics_boards/detail/'.$atim_menu_variables['StudySummary.id'].'/%%StudyEthicsBoard.id%%/',
		'bottom'=>array(
			'add'=>'/study/study_ethics_boards/add/'.$atim_menu_variables['StudySummary.id'].'/'
		)
	);
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>