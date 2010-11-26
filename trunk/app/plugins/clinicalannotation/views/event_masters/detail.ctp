<?php 

	$structure_links = array(
		'index' => array(
			'detail' => '/clinicalannotation/diagnosis_masters/detail/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%'
		),
		'bottom'=>array(
			'edit'=>'/clinicalannotation/event_masters/edit/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id'], 
			'delete'=>'/clinicalannotation/event_masters/delete/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id'], 
			'list'=>'/clinicalannotation/event_masters/listall/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id']
		)
	);

	// 1- EVENT DATA
	
	$structure_settings = array(
		'actions'=>false, 
		
		'header' => '1- ' . __('data', null),
		'form_bottom'=>false 
	);
		
	$final_atim_structure = $atim_structure;
	$final_options = array('links'=>$structure_links, 'settings'=>$structure_settings);
	
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
	
	$structures->build( $final_atim_structure, $final_options );	
	
	// 2- DIAGNOSTICS
	
	$structure_settings = array(
		'form_inputs'=>false,
		'pagination'=>false,
			
		'header' => '2- ' . __('related diagnosis', null), 
		'form_top' => false
	);
		
	$final_atim_structure = $diagnosis_structure;
	$final_options = array('links'=>$structure_links, 'type' => 'index', 'settings' => $structure_settings, 'data' => $dx_data); 
	
	$hook_link = $structures->hook('dx_list');
	if( $hook_link ) { require($hook_link); }
	
	$structures->build( $final_atim_structure, $final_options );

?>