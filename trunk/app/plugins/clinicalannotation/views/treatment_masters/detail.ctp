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
	$structure_settings = array(
		'form_bottom' => false, 
		'pagination' => false,
		'actions' => false,
		'header' => __('diagnosis', null)
	);
	$final_options = array('data' => $diagnosis_data, 'type' => 'index', 'settings' => $structure_settings, 'links' => $structure_links);
	$final_atim_structure = $diagnosis_structure;
	 $hook_link = $structures->hook('dx_list');
	if( $hook_link ) { require($hook_link); } 
	$structures->build( $final_atim_structure,  $final_options);	
	
	
	$structure_override = array('TreatmentMaster.protocol_id'=>$protocol_list);
	$final_options = array('links'=>$structure_links,'override'=>$structure_override);
	$final_atim_structure = $atim_structure; 
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
	$structures->build( $final_atim_structure, $final_options );
?>