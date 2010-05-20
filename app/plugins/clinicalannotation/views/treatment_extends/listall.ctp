<?php
	$structure_links = array(
		'index' => array(
			'detail' => '/clinicalannotation/treatment_extends/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/%%TreatmentExtend.id%%/'
		),
		'bottom' => array(
			'import from associated protocol' => '/clinicalannotation/treatment_extends/importFromProtocol/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'],
			'add' => '/clinicalannotation/treatment_extends/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id']
		)
	);
	
	$structure_override = array();
	if(!empty($drug_list)) { $structure_override['TreatmentExtend.drug_id'] = $drug_list; }
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index', 'links'=>$structure_links,'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );

?>