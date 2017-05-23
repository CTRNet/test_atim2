<?php
	$structure_links = array(
		'top'=>NULL,
		'index'=> array(
			'detail' => '/Study/StudyInvestigators/detail/'.$atim_menu_variables['StudySummary.id'].'/%%StudyInvestigator.id%%',
			'edit' => '/Study/StudyInvestigators/edit/'.$atim_menu_variables['StudySummary.id'].'/%%StudyInvestigator.id%%',
			'delete' => '/Study/StudyInvestigators/delete/'.$atim_menu_variables['StudySummary.id'].'/%%StudyInvestigator.id%%',)
					,
		'bottom'=>array(
			'add'=>'/Study/StudyInvestigators/add/'.$atim_menu_variables['StudySummary.id'].'/'
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