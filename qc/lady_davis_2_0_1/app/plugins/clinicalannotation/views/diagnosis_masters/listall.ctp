<?php 
	
	$add_links = array();
	foreach ($diagnosis_controls_list as $diagnosis_control) {
		$add_links[$diagnosis_control['DiagnosisControl']['controls_type']] = '/clinicalannotation/diagnosis_masters/add/'.$atim_menu_variables['Participant.id'].'/'.$diagnosis_control['DiagnosisControl']['id'].'/';
	}

	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/diagnosis_masters/detail/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%'),
		'bottom'=>array(
			'add' => $add_links
		)
	);
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>
