<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/clinicalannotation/diagnosis_masters/edit/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
			'add' => '/underdevelopment/',
			'redefine unknown primary' => '/underdevelopment/',
			'delete'=>'/clinicalannotation/diagnosis_masters/delete/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
			'list'=>'/clinicalannotation/diagnosis_masters/listall/%%DiagnosisMaster.participant_id%%/'
		)
	);
	
	if(isset($primary_ctrl_to_redefine_unknown) && !empty($primary_ctrl_to_redefine_unknown)) {
		$redefine_links = array();
		foreach ($primary_ctrl_to_redefine_unknown as $diagnosis_control){
			$redefine_links[__($diagnosis_control['DiagnosisControl']['controls_type'], true)] = '/clinicalannotation/diagnosis_masters/edit/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/'.$diagnosis_control['DiagnosisControl']['id'];
		}
		ksort($redefine_links);
		$structure_links['bottom']['redefine unknown primary'] = $redefine_links;	
	} else {
		unset($structure_links['bottom']['redefine unknown primary']);
	}
	
	if(isset($child_controls_list) && !empty($child_controls_list)) {
		$add_links = array();
		foreach ($child_controls_list as $diagnosis_control){
			$add_links[__($diagnosis_control['DiagnosisControl']['category'], true) . ' - ' . __($diagnosis_control['DiagnosisControl']['controls_type'], true)] = '/clinicalannotation/diagnosis_masters/add/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/'.$diagnosis_control['DiagnosisControl']['id'];
		}
		ksort($add_links);
		$structure_links['bottom']['add'] = $add_links;	
	} else {
		unset($structure_links['bottom']['add']);
	}
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>