<?php
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/clinicalannotation/treatment_extends/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/%%TreatmentExtend.id%%',
			'delete'=>'/clinicalannotation/treatment_extends/delete/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/%%TreatmentExtend.id%%',
			'list'=>'/clinicalannotation/treatment_extends/listall/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id']
		)
	);
	
	$structure_override = array();
	if(!empty($drug_list)) { $structure_override['TreatmentExtend.drug_id'] = $drug_list; }
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links,'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>