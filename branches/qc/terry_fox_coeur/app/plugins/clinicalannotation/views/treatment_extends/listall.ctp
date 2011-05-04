<?php
	$structure_links = array(
		'index' => array(
			'detail' => '/clinicalannotation/treatment_extends/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/%%TreatmentExtend.id%%/'
		),
		'bottom' => array(
			'add' => '/clinicalannotation/treatment_extends/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id']
		)
	);
	
	if(isset($extended_data_import_process)) {
		$structure_links['bottom']['import from associated protocol'] = '/clinicalannotation/treatment_extends/'.$extended_data_import_process.'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'];
	}
		
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index', 'links'=>$structure_links,'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );

?>