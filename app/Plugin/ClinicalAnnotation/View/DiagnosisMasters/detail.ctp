<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/ClinicalAnnotation/DiagnosisMasters/edit/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
			'delete'=>'/ClinicalAnnotation/DiagnosisMasters/delete/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
			'add diagnosis' => null,
			'add event' => null,
			'redefine unknown primary' => '/underdevelopment/',
			'list'=>'/ClinicalAnnotation/DiagnosisMasters/listall/%%DiagnosisMaster.participant_id%%/'
		)
	);
	
	if(isset($primary_ctrl_to_redefine_unknown) && !empty($primary_ctrl_to_redefine_unknown)) {
		$redefine_links = array();
		foreach ($primary_ctrl_to_redefine_unknown as $diagnosis_control){
			$redefine_links[__($diagnosis_control['DiagnosisControl']['controls_type'])] = '/ClinicalAnnotation/DiagnosisMasters/edit/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/'.$diagnosis_control['DiagnosisControl']['id'];
		}
		ksort($redefine_links);
		$structure_links['bottom']['redefine unknown primary'] = $redefine_links;	
	} else {
		unset($structure_links['bottom']['redefine unknown primary']);
	}
	
	if(isset($child_controls_list) && !empty($child_controls_list)) {
		$structure_links['bottom']['add diagnosis'] = $child_controls_list;
	} else {
		unset($structure_links['bottom']['add diagnosis']);
	}
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
?>