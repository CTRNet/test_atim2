<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/study/study_summaries/listall/',
			'edit'=>'/study/study_summaries/edit/%%StudySummary.id%%/',
			'delete'=>'/study/study_summaries/delete/%%StudySummary.id%%/',
			'add' => array(
				__('tool_contact', null) => '/study/study_contacts/add/%%StudySummary.id%%/',
				__('tool_ethics', null) => '/study/study_ethics_boards/add/%%StudySummary.id%%/',
				__('tool_funding', null) => '/study/study_fundings/add/%%StudySummary.id%%/',
				__('tool_investigator', null) => '/study/study_investigators/add/%%StudySummary.id%%/',
				__('tool_related studies', null) => '/study/study_related/add/%%StudySummary.id%%/',
				__('tool_result', null) => '/study/study_results/add/%%StudySummary.id%%/'
				)
		)
	);
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>