<?php 
	$structure_links = array(
		'top'=>'/Study/StudyEthicsBoards/edit/'.$atim_menu_variables['StudySummary.id'].'/%%StudyEthicsBoard.id%%/',
		'bottom'=>array(
			'cancel'=>'/Study/StudyEthicsBoards/detail/'.$atim_menu_variables['StudySummary.id'].'/%%StudyEthicsBoard.id%%/'
		)
	);
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
?>