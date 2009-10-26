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
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>
