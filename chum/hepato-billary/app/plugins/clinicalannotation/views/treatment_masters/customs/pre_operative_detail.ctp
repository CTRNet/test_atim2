<?php

	$structure_links = array(
		'top'=> '/clinicalannotation/treatment_masters/preOperativeDetail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/',
		'bottom' => array('edit' => '/clinicalannotation/treatment_masters/preOperativeEdit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/'),
		'index' => '/clinicalannotation/event_masters/detail/%%EventControl.event_group%%/%%EventMaster.participant_id%%/%%EventMaster.id%%/'
	);
	
	// ************** EVENTS **************
	
	$structure_settings = array(
		'form_top'=>true, 
		'form_bottom'=>false, 
		'form_inputs'=>false,
		'actions'=>false,
		'pagination'=>false,
		'header'=>null
	);
	
	$is_first = true;
	foreach($surgeries_events_data as $foreign_key_id => $new_events_list) {
		$structure_settings['form_top'] = $is_first? true : false;
		$structure_settings['header'] = $new_events_list['header'];
		
		$final_atim_structure = $new_events_list['structure']; 
		
		$final_options = array(
			'type'		=> 'index', 
			'data'		=> $new_events_list['data'], 
			'settings'	=> $structure_settings, 
			'links'		=> $structure_links,
		);
	
		$structures->build( $final_atim_structure, $final_options );
		
		$is_first = false;
	}	
	
	// ************** CIRRHOSIS **************
	
	unset($structure_links['top']);
	unset($structure_links['index']);
	
	$structure_settings = array(
		'form_top'=>false, 
		'header' => __('cirrhosis data', true)
	);	

	$final_atim_structure = $atim_structure; 
		
	$final_options = array(
		'type'		=> 'detail',  
		'data' => $this->data,
		'settings'	=> $structure_settings, 
		'links'		=> $structure_links,
	);

	$structures->build( $final_atim_structure, $final_options );

?>