<?php 
	$structure_links = array(
		'top'=>'/ClinicalAnnotation/DiagnosisMasters/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['tableId'].'/'.$atim_menu_variables['DiagnosisMaster.parent_id'].'/',
		'bottom'=>array(
			'cancel'=>'/ClinicalAnnotation/DiagnosisMasters/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	// 1- DIAGNOSTIC DATA
	
	$structure_settings = array(
		'tabindex' => 100,
		'header' => __('new '.$dx_ctrl['DiagnosisControl']['category']) . ' : ' . __($dx_ctrl['DiagnosisControl']['controls_type'], null)
	);
	
	$override = array();
	if($dx_ctrl['DiagnosisControl']['id'] == 15){
		//unknown primary, add a disease code
		$override['DiagnosisMaster.icd10_code'] = 'D489';
	}

	$final_atim_structure = $atim_structure;
	$final_options = array(
		'links'		=> $structure_links, 
		'settings'	=> $structure_settings,
		'override'	=> $override
	);
	
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
	
	$this->Structures->build( $final_atim_structure, $final_options );
