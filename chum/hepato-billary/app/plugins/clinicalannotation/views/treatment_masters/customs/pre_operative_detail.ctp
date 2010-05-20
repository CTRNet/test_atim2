<?php
	$top['top'] = '/clinicalannotation/treatment_masters/preOperativeDetail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/';
	$bottom['bottom']['edit'] = '/clinicalannotation/treatment_masters/preOperativeEdit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/';
	
	$options = array('setting' => array(
		'form_bottom'=>false, 
		'form_inputs'=>false,
		'actions'=>false,
		'pagination'=>false,
	));
	printMiddleStructure($this->data, $lab_reports_data, $eventmasters_structure, "lab_report_id", "lab", $top, $structures);
	printMiddleStructure($this->data, $imagings_data, $eventmasters_structure, "imagery_id", "medical imaging", $top, $structures);
	printMiddleStructure($this->data, $score_fong_data, $score_fong_structure, "fong_score_id", "fong score", $top, $structures);
	printMiddleStructure($this->data, $score_meld_data, $score_meld_structure, "meld_score_id", "meld score", $top, $structures);
	printMiddleStructure($this->data, $score_gretch_data, $score_gretch_structure, "gretch_score_id", "gretch score", $top, $structures);
	printMiddleStructure($this->data, $score_clip_data, $score_clip_structure, "clip_score_id", "clip score", $top, $structures);
	printMiddleStructure($this->data, $score_barcelona_data, $score_barcelona_structure, "barcelona_score_id", "barcelona score", $top, $structures);
	printMiddleStructure($this->data, $score_okuda_data, $score_okuda_structure, "okuda_score_id", "okuda score", $top, $structures);
	
	$structure_settings = array(
		'header' => __('cirrhosis data', null)
	);
	$options = array('links' => $bottom, 'settings' => $structure_settings);
	$structures->build($atim_structure, $options);
	
	function printMiddleStructure($main_data, $curr_data, $curr_structure, $id_name, $header_name, $top, $structures_obj){
		$links = array_merge($top, array('index' => "/clinicalannotation/event_masters/detail/%%EventMaster.event_group%%/%%EventMaster.participant_id%%/%%EventMaster.id%%/"));
		$structure_settings = array(
			'form_top' => false,
			'form_bottom' => false, 
			'form_inputs' => false,
			'actions' => false,
			'pagination' => false,
			'header' => __($header_name, null)
		);
		$options = array('links' => $links, 'type' => 'index', 'data' => $curr_data, 'settings' => $structure_settings);
		$structures_obj->build($curr_structure, $options);
	}
?>