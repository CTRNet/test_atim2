<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/clinicalannotation/diagnosis_masters/edit/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
			'add diagnosis' => null,
			'add event' => null,
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
		$structure_links['bottom']['add diagnosis'] = $child_controls_list;
	} else {
		unset($structure_links['bottom']['add diagnosis']);
	}
	
// 	foreach($event_controls as $event_control){
// 		$links = array();
// 		foreach($event_controls as $event_control){
// 			$links[sprintf("%05d", $event_control['EventControl']['display_order']).'-'.$event_control['EventControl']]
// 		}
// 	}
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>