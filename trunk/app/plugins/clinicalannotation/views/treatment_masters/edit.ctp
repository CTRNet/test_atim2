<?php 
	// Setup diagnosis radio-button pick list for linking treatment to a diagnosis
	$structure_settings = array(
		'form_bottom'=>false, 
		'form_inputs'=>false,
		'actions'=>false,
		'pagination'=>false
	);
	
	$structure_links = array(
		'radiolist'=>array(
			'EventMaster.diagnosis_id'=>'%%DiagnosisMaster.id'.'%%'
		)
	);
			
	$structures->build( $atim_structure_for_checklist, array( 'type'=>'radiolist', 'settings'=>$structure_settings, 'data'=>$data_for_checklist, 'links'=>$structure_links ) );

	// Setup treatment add form and links for display
	$structure_links = array(
		'top'=>'/clinicalannotation/treatment_masters/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'],
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/treatment_masters/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id']
		)
	);
	
	$structure_override = array('TreatmentMaster.protocol_id'=>$protocol_list);
	$structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>