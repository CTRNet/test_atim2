<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/treatment_extends/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/'.$atim_menu_variables['TreatmentExtend.id'],
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/treatment_extends/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/'.$atim_menu_variables['TreatmentExtend.id']
		)
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links,'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>