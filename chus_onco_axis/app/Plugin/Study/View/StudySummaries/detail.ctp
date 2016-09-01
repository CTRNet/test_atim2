<?php 

	$display_study_investigators = true;
	$display_study_fundings = true;
	
	//---------------------------------------------------------------------------------------------------------------------------------------------------------------
	// StudySummary
	//---------------------------------------------------------------------------------------------------------------------------------------------------------------

	$structure_links = array(
		'bottom'=>array(
			'edit'		=> '/Study/StudySummaries/edit/%%StudySummary.id%%/',
			'delete'	=> '/Study/StudySummaries/delete/%%StudySummary.id%%/'
		)
	);
	if($display_study_investigators) $structure_links['bottom']['add']['study investigator'] = '/Study/StudyInvestigators/add/'.$atim_menu_variables['StudySummary.id'];
	if($display_study_fundings) $structure_links['bottom']['add']['study funding'] = '/Study/StudyFundings/add/'.$atim_menu_variables['StudySummary.id'];
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'settings' => array('actions' => (!$display_study_investigators && !$display_study_fundings)),
		'links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
	//---------------------------------------------------------------------------------------------------------------------------------------------------------------
	// StudyInvestigator
	//---------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	$final_atim_structure = $empty_structure;
	$final_options = array(
		'links'		=> $structure_links,
		'settings'	=> array(
			'header' => __('study investigator'), 
			'actions' => (!$display_study_fundings)),
		'extras'	=> $this->Structures->ajaxIndex('/Study/StudyInvestigators/listall/'.$atim_menu_variables['StudySummary.id'])
	);
	
	$hook_link = $this->Structures->hook('study_investigator');
	if($hook_link){
		require($hook_link);
	}
	
	if($display_study_investigators) $this->Structures->build($final_atim_structure, $final_options);
	
	//---------------------------------------------------------------------------------------------------------------------------------------------------------------
	// StudyInvestigator
	//---------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	$final_atim_structure = $empty_structure;
	$final_options = array(
		'links'		=> $structure_links,
		'settings'	=> array('header' => __('study funding')),
		'extras'	=> $this->Structures->ajaxIndex('/Study/StudyFundings/listall/'.$atim_menu_variables['StudySummary.id'])
	);
	
	$hook_link = $this->Structures->hook('study_funding');
	if($hook_link){
		require($hook_link);
	}
	
	if($display_study_fundings) $this->Structures->build($final_atim_structure, $final_options);	
	
?>