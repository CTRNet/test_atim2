<?php 
	$structure_links = array(
		'top'=>'/ClinicalAnnotation/TreatmentExtendMasters/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/'.$atim_menu_variables['TreatmentExtendMaster.id'],
		'bottom'=>array(
			'cancel'=>'/ClinicalAnnotation/TreatmentMasters/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id']
		)
	);
	
	$structure_override = array();
	
	$structure_settings = array('header' => ($tx_extend_type? __($tx_extend_type, null) : __('precision', null)));	
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links,'override'=>$structure_override, 'settings' => $structure_settings);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>