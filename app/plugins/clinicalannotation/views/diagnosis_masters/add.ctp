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
		'header' => __('add new', true) . ' ' . __($dx_ctrl['DiagnosisControl']['category'], NULL) . ': ' . __($dx_ctrl['DiagnosisControl']['controls_type'], null)
	);

	$final_atim_structure = $atim_structure;
	$final_options = array('links'=>$structure_links, 'settings' => $structure_settings);
	
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
	
	$structures->build( $final_atim_structure, $final_options );
