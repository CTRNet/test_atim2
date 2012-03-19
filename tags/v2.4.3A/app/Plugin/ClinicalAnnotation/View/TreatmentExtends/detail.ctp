<?php
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/ClinicalAnnotation/TreatmentExtends/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/%%TreatmentExtend.id%%',
			'delete'=>'/ClinicalAnnotation/TreatmentExtends/delete/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/%%TreatmentExtend.id%%',
			'list'=>'/ClinicalAnnotation/TreatmentMasters/listall/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id']
		)
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links,'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>