<?php 

	$structure_links = array(
		'bottom'=>array(
			'list'=>'/clinicalannotation/treatment_masters/listall/'.$atim_menu_variables['Participant.id'].'/',
			'edit'=>'/clinicalannotation/treatment_masters/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'],
			'delete'=>'/clinicalannotation/treatment_masters/delete/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id']
		),
		'index' => array(
			'detail' => '/clinicalannotation/diagnosis_masters/detail/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%'
		)
	);
	
	// 1- TRT DATA
	
	$structure_settings = array(
		'actions'=>false, 
		
		'header' => '1- ' . __('data', null),
		'form_bottom'=>false 
	);
	
	$structure_override = array();
	
	$final_options = array('links'=>$structure_links,'settings'=>$structure_settings,'override'=>$structure_override);
	$final_atim_structure = $atim_structure; 
	
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
	
	$final_options = array('data' => $diagnosis_data, 'type' => 'index', 'settings' => $structure_settings, 'links' => $structure_links);
	$final_atim_structure = $diagnosis_structure;
	
	$hook_link = $structures->hook('dx_list');
	if( $hook_link ) { require($hook_link); }
	 
	$structures->build( $final_atim_structure,  $final_options);	
	
?>