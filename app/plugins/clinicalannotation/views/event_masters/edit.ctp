<?php 
	
	$structure_settings = array(
		'form_bottom'=>false, 
		'form_inputs'=>false,
		'actions'=>false,
		'pagination'=>false
	);

	$structure_links = array(
			'top'=>'/clinicalannotation/event_masters/edit/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id'],
			'radiolist'=>array(
				'EventMaster.diagnosis_master_id'=>'%%DiagnosisMaster.id'.'%%'
			)
		);

	$final_atim_structure = $diagnosis_structure;
	$final_options = array( 'type'=>'radiolist', 'settings'=>$structure_settings, 'data'=>$data_for_checklist, 'links'=>$structure_links );
	$hook_link = $structures->hook('dx_list');
	if( $hook_link ) { require($hook_link); }
	$structures->build( $diagnosis_structure,  $final_options);
	
	$structure_settings = array(
		'form_top'=>false
	);

	$structure_links = array(
		'top'=>'#',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/event_masters/detail/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id']
		)
	);
	
	$final_atim_structure = $atim_structure;
	$final_options = array( 'settings'=>$structure_settings, 'links'=>$structure_links );
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
	$structures->build( $final_atim_structure, $final_options);
	
?>