<?php 

	$final_options_links = array();
	$final_options_links['bottom'] = array_merge(
		array('add' => array(
			'Investigator' => '/Study/StudyInvestigators/add/'.$atim_menu_variables['StudySummary.id'].'/',
			'Funding' => '/Study/StudyFundings/add/'.$atim_menu_variables['StudySummary.id'].'/')),
		$final_options['links']['bottom']
	);

	$final_options['settings']['actions'] = false;
	$this->Structures->build( $final_atim_structure, $final_options );

	// Investigators
	
	$final_atim_structure = array();
	$final_options = array(
			'type' => 'detail',
			'links'	=> array(),
			'settings' => array(
					'header' => __('Investigator', null),
					'actions'	=> false),
			'extras' => $this->Structures->ajaxIndex('Study/StudyInvestigators/listall/'.$atim_menu_variables['StudySummary.id'].'/')
	);
	$this->Structures->build( $final_atim_structure, $final_options );
	
	// Founding
	
	$final_atim_structure = array();
	$final_options = array(
			'type' => 'detail',
			'links'	=> $final_options_links,
			'settings' => array(
					'header' => __('Funding', null),
					'actions'	=> true),
			'extras' => $this->Structures->ajaxIndex('Study/StudyFundings/listall/'.$atim_menu_variables['StudySummary.id'].'/')
	);
	
?>