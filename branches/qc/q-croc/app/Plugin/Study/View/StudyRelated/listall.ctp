<?php
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/Study/StudyRelated/detail/'.$atim_menu_variables['StudySummary.id'].'/%%StudyRelated.id%%/',
		'bottom'=>array(
			'add'=>'/Study/StudyRelated/add/'.$atim_menu_variables['StudySummary.id'].'/'
		)
	);
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
?>