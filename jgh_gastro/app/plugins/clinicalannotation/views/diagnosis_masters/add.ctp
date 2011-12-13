<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/diagnosis_masters/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['DiagnosisMaster.parent_id'].'/'.$atim_menu_variables['tableId'].'/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/diagnosis_masters/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	// 1- DIAGNOSTIC DATA
	
	$structure_settings = array(
		'tabindex' => 100,
		'header' => __('new '.$dx_ctrl['DiagnosisControl']['category'], true) . ' : ' . __($dx_ctrl['DiagnosisControl']['controls_type'], null)
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
	
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
	
	$structures->build( $final_atim_structure, $final_options );
